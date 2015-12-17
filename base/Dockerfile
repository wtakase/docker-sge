FROM centos:6.7
MAINTAINER wtakase <wataru.takase@kek.jp>
RUN yum install -y openssh-server openssh-clients nfs-utils epel-release perl-XML-Simple
RUN yum install -y http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-8.1.8-1.el6.x86_64.rpm \
                   http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-execd-8.1.8-1.el6.x86_64.rpm
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN echo "HostbasedAuthentication yes" >> /etc/ssh/ssh_config && \
    echo "EnableSSHKeysign yes" >> /etc/ssh/ssh_config 
RUN sed -i -e 's/^#HostbasedAuthentication no/HostbasedAuthentication yes/g' \
           -e 's/^#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
EXPOSE 22
