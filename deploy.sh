#!/bin/bash

set -e

kubectl apply -f ./k8s/namespace.yaml \
              -f ./k8s/secrets.yaml \
              -f ./k8s/postgres.yaml \
              -f ./k8s/fluentd.yaml \
              -f ./k8s/api.yaml
