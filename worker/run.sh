#!/bin/bash

ssh-keyscan -t rsa ${SGEMASTER_PORT_22_TCP_ADDR} >> /etc/ssh/ssh_known_hosts
echo ${SGEMASTER_PORT_22_TCP_ADDR} >> /etc/ssh/shosts.equiv
/sbin/service rpcbind start
mount -t nfs ${NFSHOME_PORT_2049_TCP_ADDR}:/exports /home
mount -t nfs ${NFSOPT_PORT_2049_TCP_ADDR}:/exports /opt
useradd -u 10000 sgeuser
exec /usr/sbin/sshd -D
