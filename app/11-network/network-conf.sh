#!/bin/sh

#terraform apply 11-network
for instance in worker-0 worker-1 worker-2; do
  gcloud compute instances describe ${instance} \
    --format 'value[separator=" "](networkInterfaces[0].networkIP,metadata.items[0].value)'
done

for i in 0 1 2; do
  gcloud compute routes create kubernetes-route-172-17-${i}-0-24 \
    --network rmorilha-kubernetes \
    --next-hop-address 172.16.238.2${i} \
    --destination-range 172.17.${i}.0/24
done

gcloud compute routes list --filter "network: rmorilha-kubernetes"
