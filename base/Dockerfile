FROM centos:6.7
MAINTAINER wtakase <wataru.takase@kek.jp>

RUN yum install -y epel-release && \
    yum install -y openssh-server openssh-clients nfs-utils epel-release \
                   perl-XML-Simple sudo rpm-build jemalloc-devel openssl-devel \
                   ncurses-devel pam-devel libXmu-devel hwloc-devel java-devel \
                   javacc ant-junit ant-nodeps swing-layout /usr/include/db.h \
                   /usr/include/Xm/Xm.h gcc /bin/csh tar

RUN sed -i -e "s/Defaults *requiretty.*/#Defaults requiretty/g" /etc/sudoers
RUN useradd -d /home/rpmbuild --shell=/bin/bash rpmbuild && \
    sudo -u rpmbuild echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
ADD skip_cl_com_compare_hosts.patch /tmp/skip_cl_com_compare_hosts.patch
RUN curl -o /usr/local/src/gridengine-8.1.8-1.src.rpm \
            https://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-8.1.8-1.src.rpm && \
    sudo -u rpmbuild rpm -ivh /usr/local/src/gridengine-8.1.8-1.src.rpm && \
    mv /tmp/skip_cl_com_compare_hosts.patch /home/rpmbuild/rpmbuild/SOURCES/ && \
    sed -i -e "s/\Release:.*/Release: wtakase1%{?dist}/" \
           -e "/^Source2:.*/a Patch10: skip_cl_com_compare_hosts.patch" \
           -e "/^\%build/i %patch10 -p1" /home/rpmbuild/rpmbuild/SPECS/gridengine.spec && \
    sudo -u rpmbuild rpmbuild -bb /home/rpmbuild/rpmbuild/SPECS/gridengine.spec && \
    yum install -y /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-8.1.8-wtakase1.el6.x86_64.rpm \
                   /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-execd-8.1.8-wtakase1.el6.x86_64.rpm \
                   /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-qmaster-8.1.8-wtakase1.el6.x86_64.rpm \
                   /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-qmon-8.1.8-wtakase1.el6.x86_64.rpm && \
    rm -rf /home/rpmbuild/rpmbuild && \
    rm -f /usr/local/src/gridengine-8.1.8-1.src.rpm

RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN echo "source /opt/sge/default/common/settings.sh" >> /etc/profile.d/sge.sh
RUN sed -i -e "s/^hosts:.*/hosts:      dns files/g" /etc/nsswitch.conf

EXPOSE 22
