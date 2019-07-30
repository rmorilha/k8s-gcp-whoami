#!/bin/sh

docker build -t rmorilha/k8stools .

if [ $? -eq 0 ]; then
    docker run -it \
        -v $PWD/app:/opt/app \
        -p 8001:8001 \
        --name k8stools rmorilha/k8stools
fi
