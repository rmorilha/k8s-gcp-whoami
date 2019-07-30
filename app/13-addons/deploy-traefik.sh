#!/bin/sh

kubectl apply -f traefik-rbac.yml
kubectl apply -f traefik-ds.yml

gcloud compute firewall-rules create rmorilha-kubernetes-allow-web \
  --allow tcp:80,tcp:8080,tcp:8888,tcp:8000,tcp:8070 \
  --network rmorilha-kubernetes \
  --source-ranges 0.0.0.0/0
