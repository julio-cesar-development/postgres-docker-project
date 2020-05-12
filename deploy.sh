#!/bin/bash

# self signed certificate
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=pg-project.blackdevs.com.br/O=pg-project.blackdevs.com.br"

# kubectl create secret tls tls-secret --key tls.key --cert tls.crt --namespace blackdevs --dry-run --output yaml > ./k8s/tls-secret.yaml

# ingress controller
kubectl apply -f ./k8s/nginx-ingress-controller.yaml

# namespace
kubectl apply -f ./k8s/namespace.yaml
# secrets
kubectl apply -f ./k8s/secrets.yaml
# tls secret
kubectl apply -f ./k8s/tls-secret.yaml

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
kubectl apply -f ./k8s/fluentd-deployment.yaml

#### API ####
# API service
kubectl apply -f ./k8s/api-svc.yaml
# API deployment
kubectl apply -f ./k8s/api-deployment.yaml
# ingress service
kubectl apply -f ./k8s/ingress-svc.yaml
