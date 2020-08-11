#!/bin/bash

set -e

kubectl delete -f ./secrets.yaml \
              -f ./postgres.yaml \
              -f ./fluentd.yaml \
              -f ./api.yaml
