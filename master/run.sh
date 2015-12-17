#!/bin/bash

mv /opt/sge /tmp/
/sbin/service rpcbind start
mount -t nfs ${NFSHOME_PORT_2049_TCP_ADDR}:/exports /home
mount -t nfs ${NFSOPT_PORT_2049_TCP_ADDR}:/exports /opt
rm -rf /opt/sge
mv /tmp/sge /opt/
useradd -u 10000 sgeuser
sed -e 's/^SGE_JMX_PORT=.*/SGE_JMX_PORT="6666"/' \
    -e 's/^SGE_JMX_SSL_KEYSTORE=.*/SGE_JMX_SSL_KEYSTORE="\/tmp"/' \
    -e 's/^SGE_JMX_SSL_KEYSTORE_PW=.*/SGE_JMX_SSL_KEYSTORE_PW="\/tmp"/' \
    -e 's/^SGE_JVM_LIB_PATH=.*/SGE_JVM_LIB_PATH="\/tmp"/' \
    -e 's/^ADMIN_HOST_LIST=.*/ADMIN_HOST_LIST=\`hostname\`/' \
    -e 's/^SUBMIT_HOST_LIST=.*/SUBMIT_HOST_LIST=\`hostname\`/' \
    -e 's/^EXEC_HOST_LIST=.*/EXEC_HOST_LIST=""/' \
    /opt/sge/util/install_modules/inst_template.conf > /opt/sge/install_sge_master.conf
sed -e 's/^EXEC_HOST_LIST=.*/EXEC_HOST_LIST=\`hostname\`/' \
    /opt/sge/install_sge_master.conf > /opt/sge/install_sge_worker.conf
(cd /opt/sge; ./inst_sge -m -auto ./install_sge_master.conf)
exec /usr/sbin/sshd -D
