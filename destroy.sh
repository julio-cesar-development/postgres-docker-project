#!/bin/bash

kubectl delete \
  -f ./k8s/secrets.yaml \
  -f ./k8s/pg-data.yaml \
  -f ./k8s/pg-svc.yaml \
  -f ./k8s/pg-statefulset.yaml \
  -f ./k8s/fluentd-data.yaml \
  -f ./k8s/fluentd-svc.yaml \
  -f ./k8s/fluentd-deployment.yaml \
  -f ./k8s/api-svc.yaml \
  -f ./k8s/api-deployment.yaml \
  -f ./k8s/ingress-svc.yaml \
  -f ./k8s/ingress-local-svc.yaml
