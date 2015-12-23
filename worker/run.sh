#!/bin/bash

/sbin/service rpcbind start
mount -t nfs ${NFSHOME_PORT_2049_TCP_ADDR}:/ /home
mount -t nfs ${NFSOPT_PORT_2049_TCP_ADDR}:/ /opt
useradd -u 10000 sgeuser
echo "sgeuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
(sleep 10; sudo -u sgeuser bash -c "ssh ${SGEMASTER_PORT_22_TCP_ADDR} \"sudo bash -c '. /etc/profile.d/sge.sh; qconf -ah ${HOST_NAME:=${HOSTNAME}}; qconf -as ${HOST_NAME:=${HOSTNAME}}'\""; cd /opt/sge; ./inst_sge -x -auto ./install_sge_worker.conf -nobincheck -noremote) &
exec /usr/sbin/sshd -D
