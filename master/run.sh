#!/bin/bash

mv /opt/sge /tmp/
/sbin/service rpcbind start
mount -t nfs ${NFSHOME_PORT_2049_TCP_ADDR}:/ /home
mount -t nfs ${NFSOPT_PORT_2049_TCP_ADDR}:/ /opt
if [ -z "${NOT_INIT}" ]; then
    rm -rf /opt/sge
    rm -rf /home/sgeuser
fi
mv /tmp/sge /opt/
useradd -u 10000 sgeuser
sudo -u sgeuser bash -c 'ssh-keygen -q -f ~/.ssh/id_rsa -t rsa -P ""'
sudo -u sgeuser bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys'
sudo -u sgeuser bash -c 'echo -e "Host *\n   StrictHostKeyChecking no\n   UserKnownHostsFile=/dev/null" >> ~/.ssh/config; chmod 600 ~/.ssh/config'
echo "sgeuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -e 's/^SGE_JMX_PORT=.*/SGE_JMX_PORT="6666"/' \
    -e 's/^SGE_JMX_SSL_KEYSTORE=.*/SGE_JMX_SSL_KEYSTORE="\/tmp"/' \
    -e 's/^SGE_JMX_SSL_KEYSTORE_PW=.*/SGE_JMX_SSL_KEYSTORE_PW="\/tmp"/' \
    -e 's/^SGE_JVM_LIB_PATH=.*/SGE_JVM_LIB_PATH="\/tmp"/' \
    -e 's/^HOSTNAME_RESOLVING=.*/HOSTNAME_RESOLVING="false"/' \
    -e 's/^ADMIN_HOST_LIST=.*/ADMIN_HOST_LIST=\`hostname -f\`/' \
    -e 's/^SUBMIT_HOST_LIST=.*/SUBMIT_HOST_LIST=\`hostname -f\`/' \
    -e 's/^EXEC_HOST_LIST=.*/EXEC_HOST_LIST=""/' \
    /opt/sge/util/install_modules/inst_template.conf > /opt/sge/install_sge_master.conf
sed -e 's/^EXEC_HOST_LIST=.*/EXEC_HOST_LIST=\`hostname -f\`/' \
    /opt/sge/install_sge_master.conf > /opt/sge/install_sge_worker.conf
(cd /opt/sge; ./inst_sge -m -auto ./install_sge_master.conf)
exec /usr/sbin/sshd -D
