#!/bin/bash

/sbin/service rpcbind start
mount -t nfs -o vers=3 ${NFSHOME_PORT_2049_TCP_ADDR}:/exports /home
mount -t nfs -o vers=3 ${NFSOPT_PORT_2049_TCP_ADDR}:/exports /opt
useradd -u 10000 sgeuser
echo "sgeuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
(sleep 10; sudo -u sgeuser bash -c "ssh ${SGEMASTER_PORT_22_TCP_ADDR} \"sudo bash -c '. /etc/profile.d/sge.sh; qconf -ah `hostname -f`; qconf -as `hostname -f`'\""; cd /opt/sge; ./inst_sge -x -auto install_sge_worker.conf -nobincheck) &
exec /usr/sbin/sshd -D
