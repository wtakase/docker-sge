#!/bin/sh

WORKER_NUM=$1
TIMEOUT=240
SLEEP_INTERVAL=5
SGE_DIR=kubernetes/sge

echo "# Boot ${WORKER_NUM:=1} SGE workers"
echo "" > ${SGE_DIR}/sgeworkers-pod.yaml
for i in $(seq 1 ${WORKER_NUM:=1}); do
    NAME="sgeworker-`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 16 | head -n 1`"
    if [ -n "${DNS_DOMAIN}" ]; then
        HOST_NAME="${NAME}.default.pod.${DNS_DOMAIN}"
    else
        HOST_NAME=${NAME}
    fi
    sed -e "s/      value: sgeworker001/      value: ${HOST_NAME}/g" -e "s/sgeworker001/${NAME}/g" ${SGE_DIR}/sgeworker-pod.yaml >> ${SGE_DIR}/sgeworkers-pod.yaml
done;
LAST_WORKER=$NAME

kubectl create -f ${SGE_DIR}/sgeworkers-pod.yaml
I=0
while [ $I -le $TIMEOUT ]; do
    if [ "`kubectl logs ${LAST_WORKER} 2>&1 | tail -1 | awk '{print $1}'`" = "Install" ]; then
        break
    fi
    echo "Wait SGE workers..."
    I=`expr $I + $SLEEP_INTERVAL`
    sleep $SLEEP_INTERVAL
done
kubectl get pods -l app=sgeworker
if [ $I -gt $TIMEOUT ]; then
    echo "Timeout"
    exit 1
fi
echo ""
