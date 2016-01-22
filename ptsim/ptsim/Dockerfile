FROM wtakase/sge-geant4
MAINTAINER wtakase <wataru.takase@kek.jp>

ENV PTSIM_VERSION 101-001-003-20151217
RUN /bin/bash -c "source /etc/profile.d/geant4.sh && \
    source /etc/profile.d/root.sh && \
    mkdir -p /usr/local/ptsim/{src,build/PTStoolkit} && \
    mkdir -p /usr/local/ptsim/build/PTSapps/DynamicPort && \
    mkdir -p /usr/local/ptsim/{PTStoolkit,PTSapps/DynamicPort} && \
    curl -o /usr/local/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz \
            http://wiki.kek.jp/download/attachments/5343876/PTSproject-${PTSIM_VERSION}.tar.gz && \
    tar zxf /usr/local/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz -C /usr/local/ptsim/src && \
    rm -f /usr/local/ptsim/PTSproject-${PTSIM_VERSION}.tar.gz && \
    cd /usr/local/ptsim/build/PTStoolkit && \
    cmake -DCMAKE_INSTALL_PREFIX=../../PTStoolkit \
          -DUSEIAEAPHSP=ON \
          ../../src/PTSproject/PTStoolkit && \
    make -j`grep -c processor /proc/cpuinfo` && make install && \
    cd /usr/local/ptsim/build/PTSapps/DynamicPort && \
    cmake -DUSEROOT=ON \
          -DCMAKE_INSTALL_PREFIX=../../../PTSapps/DynamicPort \
          -DUSEIAEAPHSP=ON \
          -DIAEAPHSP_WRITE_USE=ON \
          ../../../src/PTSproject/PTSapps/DynamicPort && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    rm -rf /usr/local/ptsim/{src,build}"

CMD /run.sh
