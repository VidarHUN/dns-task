#!/bin/bash                                                                                                                               
POD=$1
ENDPOINT=$2
[ -z $POD -o -z $ENDPOINT ] && echo "usage: reset_worker.sh <pod_name> <endpoint_name>" && exit 1
echo Removing pod ${POD}/${ENDPOINT}
# remove pod                                                                                                                              
kubectl delete pod $POD
curl -sX DELETE http://$(minikube ip):1234/api/v1/endpoints/${ENDPOINT}'?recursive=true'
