FROM wtakase/sge-base
MAINTAINER wtakase <wataru.takase@kek.jp>
RUN yum install -y /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-qmaster-8.1.8-wtakase1.el6.x86_64.rpm \
                   /home/rpmbuild/rpmbuild/RPMS/x86_64/gridengine-qmon-8.1.8-wtakase1.el6.x86_64.rpm
EXPOSE 6444
ADD run.sh /run.sh
RUN chmod 755 /run.sh
CMD /run.sh
