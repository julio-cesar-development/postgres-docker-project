#!/bin/bash

set -e

kubectl apply -f ./secrets.yaml \
              -f ./postgres.yaml \
              -f ./fluentd.yaml \
              -f ./api.yaml
