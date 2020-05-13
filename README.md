# Postgres/ Docker/ Node/ Fluentd project

[![Build Status](https://badgen.net/travis/julio-cesar-development/postgres-docker-project?icon=travis)](https://travis-ci.com/julio-cesar-development/postgres-docker-project)
[![GitHub Status](https://badgen.net/github/status/julio-cesar-development/postgres-docker-project)](https://github.com/julio-cesar-development/postgres-docker-project)

> A small project using containers with Docker
> To run a Postgres database and a simple API with Node JS
> Also uses Fluentd to gather logs from API and outputs it

* Instructions

> Run the project with docker-compose

```bash
docker-compose up
```

> Run the project with Kubernetes

```bash
kubectl apply -f ./k8s/

kubectl config set-context ${CURRENT_CONTEXT} --namespace=blackdevs
kubectl get pod,deploy,statefulset,svc,ingress,configmap
```
