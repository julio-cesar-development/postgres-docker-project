# Postgres/ Docker/ Typescript/ Fluentd project

[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/julio-cesar-development/postgres-docker-project)
[![Build Status](https://travis-ci.org/julio-cesar-development/postgres-docker-project.svg)](https://travis-ci.org/julio-cesar-development/postgres-docker-project)
[![GitHub Status](https://badgen.net/github/status/julio-cesar-development/postgres-docker-project)](https://github.com/julio-cesar-development/postgres-docker-project)

> A small project using containers with Docker
> To run a Postgres database and a simple API with Typescript
> Also uses Fluentd to gather logs from API and outputs it

* Instructions

> Run the project with docker-compose

```bash
docker-compose up
```

> Run the project with Kubernetes

```bash
# apply Traefik Ingress Controller, it needs to be running first
kubectl apply -f ./k8s/traefik-ingress-controller.yaml

# run deploy script
./deploy.sh

# see deployed objects
kubectl get pod,deploy,statefulset,svc,ingress,configmap,secret -n blackdevs
```
