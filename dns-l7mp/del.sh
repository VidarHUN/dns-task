#!/bin/bash

kubectl delete service dns
kubectl delete statefulset.apps dns
kubectl delete statefulset.apps test-dns
kubectl delete configmap l7mp-ingress-gw
kubectl delete daemonset.apps l7mp-ingress-gw
kubectl delete pvc config-pvc
kubectl delete pv config-pv
kubectl delete pvc test-config-pvc
kubectl delete pv test-config-pv

# If one of these stuck in terminating 
# kubectl patch pvc pvc_name -p '{"metadata":{"finalizers":null}}'
# kubectl patch pv pv_name -p '{"metadata":{"finalizers":null}}'
# kubectl patch pod pod_name -p '{"metadata":{"finalizers":null}}'