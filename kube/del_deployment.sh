#!/bin/bash

kubectl delete deployment.apps dns-dep
kubectl delete service dns-svc
kubectl delete configmaps dns-config
