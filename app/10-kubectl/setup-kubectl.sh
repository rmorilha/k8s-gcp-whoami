#!/bin/sh

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe rmorilha-kubernetes \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

kubectl config set-cluster rmorilha-kubernetes \
  --certificate-authority=./04-certs/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

kubectl config set-credentials admin \
  --client-certificate=./04-certs/admin.pem \
  --client-key=./04-certs/admin-key.pem

kubectl config set-context default \
  --cluster=rmorilha-kubernetes \
  --user=admin

kubectl config use-context default

kubectl get componentstatuses
