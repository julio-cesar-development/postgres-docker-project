#!/bin/bash

# (kubectl delete -f ./k8s 1> /dev/null 2>&1 && echo "Cleaning K8S objects...") &
# wait

# namespace
kubectl apply -f ./k8s/namespace.yaml
# secrets
kubectl apply -f ./k8s/secrets.yaml

#### Postgres ####
# pg configmap
kubectl apply -f ./k8s/pg-data.yaml
# pg service
kubectl apply -f ./k8s/pg-svc.yaml
# pg statefulset
kubectl apply -f ./k8s/pg-statefulset.yaml

#### Fluentd ####
# fluentd configmap
kubectl apply -f ./k8s/fluentd-data.yaml
# fluentd service
kubectl apply -f ./k8s/fluentd-svc.yaml
# fluentd daemonset
kubectl apply -f ./k8s/fluentd-daemonset.yaml

#### API ####
# API service
kubectl apply -f ./k8s/api-svc.yaml
# API deployment
kubectl apply -f ./k8s/api-deployment.yaml

# ingress controller
# kubectl apply -f ./k8s/ingress-controller.yaml
# ingress service
kubectl apply -f ./k8s/ingress-svc.yaml
