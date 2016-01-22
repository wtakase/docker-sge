FROM wtakase/sge-geant4-base
MAINTAINER wtakase <wataru.takase@kek.jp>

ENV GEANT4_VERSION 10.01.p02
RUN mkdir -p /usr/local/geant4/{src,build} && \
    curl -o /usr/local/geant4/geant4.${GEANT4_VERSION}.tar.gz \
            http://geant4.cern.ch/support/source/geant4.${GEANT4_VERSION}.tar.gz && \
    tar zxf /usr/local/geant4/geant4.${GEANT4_VERSION}.tar.gz -C /usr/local/geant4/src && \
    rm -f /usr/local/geant4/geant4.${GEANT4_VERSION}.tar.gz && \
    cd /usr/local/geant4/build && \
    cmake -DGEANT4_INSTALL_DATA=on \
          -DGEANT4_USE_OPENGL_X11=on \
          -DGEANT4_USE_QT=on \
          -DCMAKE_INSTALL_PREFIX=../ \
          ../src/geant4.${GEANT4_VERSION} && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    echo ". /usr/local/geant4/bin/geant4.sh" > /etc/profile.d/geant4.sh && \
    rm -rf /usr/local/geant4/{src,build}
