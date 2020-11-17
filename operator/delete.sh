#!/bin/bash

# Delete DNS deployment resources
kubectl delete deployment.apps dns-deployment
# kubectl delete pvc config-pvc
# kubectl delete pv config-pv
kubectl delete configmaps dns-sidecar-config
kubectl delete configmaps dns-config

# Delete Operator resources
kubectl delete target.l7mp.io dns-cluster
kubectl delete vsvc gateway
kubectl delete vsvc dns-listener