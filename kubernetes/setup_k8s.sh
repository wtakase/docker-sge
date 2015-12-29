#!/bin/sh

K8S_VERSION=1.1.1

docker run \
    --net=host \
    -d \
    gcr.io/google_containers/etcd:2.0.12 \
    /usr/local/bin/etcd \
    --addr=127.0.0.1:4001 \
    --bind-addr=0.0.0.0:4001 \
    --data-dir=/var/etcd/data

docker run \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    wtakase/hyperkube:v${K8S_VERSION} \
    /hyperkube kubelet \
        --containerized \
        --hostname-override="127.0.0.1" \
        --address="0.0.0.0" \
        --api-servers=http://localhost:8080 \
        --config=/etc/kubernetes/manifests-multi \
        --cluster-dns=10.0.0.10 \
        --cluster-domain=cluster.local \
        --resolv-conf="" \
        --allow-privileged=true --v=2

docker run \
    -d \
    --net=host \
    --privileged \
    wtakase/hyperkube:v${K8S_VERSION} \
    /hyperkube proxy \
    --master=http://127.0.0.1:8080 --v=2
