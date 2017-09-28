FROM ubuntu:16.04
MAINTAINER wtakase <wataru.takase@kek.jp>

RUN apt-get -y update
RUN apt-get -y install openssh-server openssh-client nfs-common rpm alien curl sudo

RUN apt-get -y build-dep gridengine
RUN apt-get -y install libjemalloc-dev libssl-dev libncurses-dev libpam-dev net-tools \
                       libxmu-dev libhwloc-dev libdb-dev libmotif-dev javacc libswing-layout-java
ADD skip_cl_com_compare_hosts.patch /tmp/skip_cl_com_compare_hosts.patch
RUN echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
RUN curl -o /usr/local/src/gridengine-8.1.8-1.src.rpm \
    https://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-8.1.8-1.src.rpm
RUN rpm -ivh /usr/local/src/gridengine-8.1.8-1.src.rpm && \
    mv /tmp/skip_cl_com_compare_hosts.patch /root/rpmbuild/SOURCES/ && \
    sed -i -e "s/\Release:.*/Release: wtakase1%{?dist}/" \
           -e "s/^BuildRequires/#BuildRequires/g" \
           -e "/^Source2:.*/a Patch10: skip_cl_com_compare_hosts.patch" \
           -e "/^\%build/i %patch10 -p1" /root/rpmbuild/SPECS/gridengine.spec
RUN rpmbuild -bb /root/rpmbuild/SPECS/gridengine.spec
RUN alien --scripts /root/rpmbuild/RPMS/x86_64/gridengine-8.1.8-wtakase1.x86_64.rpm && \
    alien --scripts /root/rpmbuild/RPMS/x86_64/gridengine-execd-8.1.8-wtakase1.x86_64.rpm && \
    alien --scripts /root/rpmbuild/RPMS/x86_64/gridengine-qmaster-8.1.8-wtakase1.x86_64.rpm && \
    alien --scripts /root/rpmbuild/RPMS/x86_64/gridengine-qmon-8.1.8-wtakase1.x86_64.rpm
RUN dpkg -i gridengine_8.1.8-1_amd64.deb \
            gridengine-execd_8.1.8-1_amd64.deb \
            gridengine-qmaster_8.1.8-1_amd64.deb \
            gridengine-qmon_8.1.8-1_amd64.deb
RUN rm -rf /root/rpmbuild && \
    rm -f gridengine*.deb && \
    rm -f /usr/local/src/gridengine-8.1.8-1.src.rpm

RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN echo "source /opt/sge/default/common/settings.sh" >> /etc/profile.d/sge.sh
RUN sed -i -e "s/^hosts:.*/hosts:      dns files/g" /etc/nsswitch.conf

RUN mkdir /run/sendsigs.omit.d && mkdir /var/run/sshd
EXPOSE 22
