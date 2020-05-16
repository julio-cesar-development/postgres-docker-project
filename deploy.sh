#!/bin/bash

set -e

DEPLOY_TYPE="${1:-"prod"}"
INGRESS_SVC_FILE='./k8s/ingress-svc.yaml'

if [ "${DEPLOY_TYPE}" == "dev" ]; then
  INGRESS_SVC_FILE='./k8s/ingress-local-svc.yaml'
fi

echo "Deploying for ${DEPLOY_TYPE} environment"


# Nginx ingress controller
kubectl apply -f ./k8s/nginx-ingress-controller.yaml

# kubectl get pods --namespace ingress-nginx
# kubectl get svc --namespace ingress-nginx


#### Namespace ####
kubectl apply -f ./k8s/namespace.yaml

CURRENT_CONTEXT=$(kubectl config view | grep "current-context" | cut -d ":" -f2 | tr -d ' ')
kubectl config set-context "${CURRENT_CONTEXT}" --namespace=blackdevs


# FQDN="pg-project.blackdevs.com.br"

#### Certificates ####
# self signed certificate
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=$FQDN/O=$FQDN"

# kubectl create secret tls tls-secret --key tls.key --cert tls.crt --namespace blackdevs --dry-run --output yaml > ./k8s/tls-secret.yaml

if [ "${DEPLOY_TYPE}" == "prod" ]; then
  # certificate with cert manager
  # docs
  # https://cert-manager.io/docs/concepts/certificate/
  # https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes-pt
  # https://www.digitalocean.com/docs/networking/dns/how-to/manage-records/
  # https://kubernetes.io/docs/concepts/services-networking/ingress/
  # https://www.terraform.io/docs/providers/acme/index.html
  # https://certbot-dns-route53.readthedocs.io/en/stable/

  # kubectl create namespace cert-manager
  kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml

  # kubectl get pods --namespace cert-manager
  # kubectl get svc --namespace cert-manager
  # kubectl get deploy --namespace cert-manager

  # tls secret
  kubectl apply -f ./k8s/tls-secret.yaml
  # issuer
  kubectl apply -f ./k8s/issuer.yaml
  # certificate
  kubectl apply -f ./k8s/certificate.yaml

  # kubectl get issuers -A
  # kubectl describe issuers -A

  # kubectl get clusterissuers -A
  # kubectl describe clusterissuers -A

  # kubectl get certificate -A
  # kubectl describe certificate -A

  # kubectl get certificaterequest -A
  # kubectl describe certificaterequest -A

  # test the certificate
  # wget --save-headers -O- "https://$FQDN/api/v1/healthcheck" --no-check-certificate
fi


#### Secrets ####
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
kubectl apply -f ./k8s/fluentd-deployment.yaml

#### API ####
# API service
kubectl apply -f ./k8s/api-svc.yaml
# API deployment
kubectl apply -f ./k8s/api-deployment.yaml


NGINX_INGRESS_CONTROLLER_STATE=$(kubectl get pod -n ingress-nginx | grep "ingress-nginx-controller" | tr -s " " ":" | cut -d":" -f3)
if [ "${DEPLOY_TYPE}" == "dev" ]; then
  # shellcheck disable=SC2166
  while [ -z "${NGINX_INGRESS_CONTROLLER_STATE}" -o "${NGINX_INGRESS_CONTROLLER_STATE,,}" != "running" ]; do
    echo "Waiting for Nginx controller..."
    sleep 5
  done
fi


# ingress service
kubectl apply -f "${INGRESS_SVC_FILE}"
