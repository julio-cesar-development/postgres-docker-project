#!/bin/bash

set -e


# apk update
# apk add postgresql
# apk add netcat-openbsd
# apk list

# network troubleshooting
# nc -vvv postgres 5432
# ping postgres

# sudo - postgres

# psql -h ${POSTGRES_HOST} -p 5432 -U ${POSTGRES_USER} -W
# psql -h postgres -p 5432 -U postgres -W

# SELECT * FROM users;

# -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
# -p, --port=PORT          database server port (default: "5432")
# -U, --username=USERNAME  database user name (default: "postgres")
# -w, --no-password        never prompt for password
# -W, --password           force password prompt (should happen automatically)

# list databases
# \l

# connect to a database
# \c ${POSTGRES_DB}
# \c postgres_db

# list tables
# \dt

# docker image build --tag juliocesarmidia/pg-project-api:latest ./api
# docker container run --rm -p 41000:40000 --name pg-project-api juliocesarmidia/pg-project-api:latest
# docker container run -it --entrypoint "" juliocesarmidia/pg-project-api:latest yarn run lint

# docker container exec -it juliocesarmidia/pg-project-api:latest sh

### tests with fping tools ###
# > dnsdomainname
# blackdevs.svc.cluster.local

# > domainname
# blackdevs.svc.cluster.local

# > hostname
# api-svc

# > nslookup pg-svc.blackdevs.svc.cluster.local
# Name:	pg-svc.blackdevs.svc.cluster.local
# Address: 172.100.10.2


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


# generate template
helm template ./ci/charts/ --debug

# install a chart
helm install ./ci/charts/ --generate-name

# uninstall a chart
helm uninstall postgres-project-0000000000

# upgrade a chart
helm upgrade postgres-project-0000000000 \
  --set api.image.tag=latest \
  ./ci/charts/


# list releases
helm ls

# update repositories
helm repo update


# format terraform (check only)
terraform fmt -check=true -write=false -diff -recursive
# format terraform
terraform fmt -recursive

terraform show
terraform refresh

terraform destroy -auto-approve
