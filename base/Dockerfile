FROM centos:6.7
MAINTAINER wtakase <wataru.takase@kek.jp>
RUN yum install -y openssh-server openssh-clients nfs-utils epel-release perl-XML-Simple sudo
RUN yum install -y http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-8.1.8-1.el6.x86_64.rpm \
                   http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-execd-8.1.8-1.el6.x86_64.rpm
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -i -e "s/Defaults *requiretty.*/#Defaults requiretty/g" /etc/sudoers
RUN echo "source /opt/sge/default/common/settings.sh" >> /etc/profile.d/sge.sh
RUN sed -i -e "s/^hosts:.*/hosts:      dns/g" /etc/nsswitch.conf
EXPOSE 22
