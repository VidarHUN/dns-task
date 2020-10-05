#!/bin/bash

kubectl delete service dns
kubectl delete statefulset.apps dns
kubectl delete configmap l7mp-ingress-gw
kubectl delete daemonset.apps l7mp-ingress-gw
