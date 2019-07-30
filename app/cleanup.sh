#!/bin/sh

#destroy web firewall
gcloud -q compute firewall-rules delete \
  rmorilha-kubernetes-allow-web || true

#terraform destroy 11-network
gcloud -q compute routes delete \
  kubernetes-route-172-17-0-0-24 \
  kubernetes-route-172-17-1-0-24 \
  kubernetes-route-172-17-2-0-24

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe rmorilha-kubernetes \
  --region $(gcloud config get-value compute/region) \
  --format 'value(name)')
#terraform destroy -var "gce_ip_address=${KUBERNETES_PUBLIC_ADDRESS}" 08-kube-master

gcloud -q compute forwarding-rules delete --region us-east4 kubernetes-forwarding-rule
gcloud -q compute target-pools delete kubernetes-target-pool

rm 07-etcd/*.retry

rm 06-encryption/encryption-config.yaml

rm 05-kubeconfig/*.kubeconfig

rm 04-certs/*.pem
rm 04-certs/*.csr

terraform destroy -var "gce_zone=${GCLOUD_ZONE}" -force 03-provisioning/
