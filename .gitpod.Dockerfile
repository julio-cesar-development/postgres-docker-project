FROM gitpod/workspace-full

RUN sudo apt-get -q -y update && \
    sudo apt-get install -q -y docker.io && \
    sudo rm -rf /var/lib/apt/lists/*
