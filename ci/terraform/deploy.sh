#!/bin/bash

terraform init -backend=true && \
    terraform validate && \
    terraform plan && \
    terraform apply -auto-approve
