FROM wtakase/sge-base
MAINTAINER wtakase <wataru.takase@kek.jp>
RUN yum install -y http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-qmaster-8.1.8-1.el6.x86_64.rpm \
                   http://arc.liv.ac.uk/downloads/SGE/releases/8.1.8/gridengine-qmon-8.1.8-1.el6.x86_64.rpm
EXPOSE 6444
ADD run.sh /run.sh
RUN chmod 755 /run.sh
CMD /run.sh
