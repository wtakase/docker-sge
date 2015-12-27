#!/bin/sh

DNS_REPLICAS=1
DNS_DOMAIN=cluster.local
DNS_SERVER_IP=10.0.0.10
DNS_DIR=kubernetes/skydns

sed -e "s/{{ pillar\['dns_replicas'\] }}/${DNS_REPLICAS}/g;s/{{ pillar\['dns_domain'\] }}/${DNS_DOMAIN}/g;s/{kube_server_url}/${KUBE_SERVER:=192.168.99.100}/g;s/gcr\.io\/google_containers\/kube2sky:.*/wtakase\/kube2sky:1.12/" ${DNS_DIR}/skydns-rc.yaml.in > ${DNS_DIR}/skydns-rc.yaml
sed -e "s/{{ pillar\['dns_server'\] }}/${DNS_SERVER_IP}/g" ${DNS_DIR}/skydns-svc.yaml.in > ${DNS_DIR}/skydns-svc.yaml

kubectl --namespace=kube-system create -f ${DNS_DIR}/skydns-rc.yaml
kubectl --namespace=kube-system create -f ${DNS_DIR}/skydns-svc.yaml
