#!/bin/sh

WORKER_NUM=$1
TIMEOUT=120
SLEEP_INTERVAL=5

echo "# Setup Kubernetes cluster"
./kubernetes/setup_k8s.sh
I=0
while [ $I -le $TIMEOUT ]; do
    if [ "`kubectl get nodes 2>&1 | grep 127.0.0.1 | awk '{print $3}'`" = "Ready" ]; then
        break
    fi
    echo "Wait Kubernetes cluster..."
    I=`expr $I + $SLEEP_INTERVAL`
    sleep $SLEEP_INTERVAL
done
kubectl get nodes
if [ $I -gt $TIMEOUT ]; then
    echo "Timeout"
    exit 1
fi
echo ""

echo "# Setup DNS service"
./kubernetes/setup_dns.sh
I=0
while [ $I -le $TIMEOUT ]; do
    if [ "`kubectl get pods --namespace=kube-system -l k8s-app=kube-dns 2>&1 | grep kube-dns-v8 | awk '{print $3}'`" = "Running" ]; then
        break
    fi
    echo "Wait DNS service..."
    I=`expr $I + $SLEEP_INTERVAL`
    sleep $SLEEP_INTERVAL
done
kubectl get pods --namespace=kube-system -l k8s-app=kube-dns
if [ $I -gt $TIMEOUT ]; then
    echo "Timeout"
    exit 1
fi
echo ""

echo "# Setup SGE cluster"
./kubernetes/setup_sge.sh $WORKER_NUM

echo "# Done all setups"
