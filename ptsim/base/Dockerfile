FROM wtakase/sge-worker
MAINTAINER wtakase <wataru.takase@kek.jp>

ENV CMAKE_SHORT_VERSION 3.4
ENV CMAKE_PATCH_VERSION 1
ENV CMAKE_VERSION ${CMAKE_SHORT_VERSION}.${CMAKE_PATCH_VERSION}
ENV ROOT_VERSION 5.34.34

RUN yum update -y
RUN yum install -y scl-utils centos-release-scl-rh && \
    yum install -y devtoolset-3-gcc-c++ tar expat-devel libXmu-devel \
                   libXt-devel freeglut-devel qt-devel libX11-devel \
                   libXpm-devel libXft-devel libXext-devel

ENV HOME /root
WORKDIR /root

RUN curl -k -o /usr/local/src/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz \
               https://cmake.org/files/v${CMAKE_SHORT_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
    tar zxf /usr/local/src/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz -C /usr/local/src/ && \
    mv /usr/local/src/cmake-${CMAKE_VERSION}-Linux-x86_64/bin/* /usr/local/bin/ && \
    mv /usr/local/src/cmake-${CMAKE_VERSION}-Linux-x86_64/share/* /usr/local/share/ && \
    rm -rf /usr/local/src/cmake-${CMAKE_VERSION}-Linux-x86_64*

RUN scl enable devtoolset-3 bash && \
    ln -s /opt/rh/devtoolset-3/enable /etc/profile.d/devtools-3.sh
ENV CC /opt/rh/devtoolset-3/root/usr/bin/gcc
ENV CXX /opt/rh/devtoolset-3/root/usr/bin/g++

RUN mkdir -p /usr/local/root/{src,build} && \
    curl -o /usr/local/root/root_v${ROOT_VERSION}.source.tar.gz \
            https://root.cern.ch/download/root_v${ROOT_VERSION}.source.tar.gz && \
    tar zxf /usr/local/root/root_v${ROOT_VERSION}.source.tar.gz -C /usr/local/root/src && \
    rm -f /usr/local/root/root_v${ROOT_VERSION}.source.tar.gz && \
    cd /usr/local/root/build && \
    cmake -DCMAKE_INSTALL_PREFIX=../ ../src/root && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    echo ". /usr/local/root/bin/thisroot.sh" > /etc/profile.d/root.sh && \
    rm -rf /usr/local/root/{src,build}
