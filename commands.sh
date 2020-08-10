#!/bin/bash

set -e

kubectl config set-context "$(kubectl config current-context)" --namespace=blackdevs


# FQDN="pg-project.blackdevs.com.br"

#### Certificates ####
# self signed certificate
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=$FQDN/O=$FQDN"

# kubectl create secret tls tls-secret --key tls.key --cert tls.crt --namespace blackdevs --dry-run --output yaml > ./k8s/tls-secret.yaml


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

helm template ./ci/postgres-project/ --debug

helm install ./ci/postgres-project/ --generate-name

helm ls

helm uninstall postgres-project-1597041126

helm repo update

helm upgrade postgres-project-1597041126 --set api.image.tag=latest ./ci/postgres-project/
