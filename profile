#!/bin/bash

source /opt/google-cloud-sdk/completion.bash.inc
source /opt/google-cloud-sdk/path.bash.inc

# For terraform
export GCLOUD_PROJECT=rmorilha-kubernetes
export GCLOUD_REGION=us-east4
export GCLOUD_ZONE=us-east4-c

# For ansible
export GCE_PROJECT=$GCLOUD_PROJECT
export GCE_PEM_PATH=/opt/app/keys.json
export GCE_EMAIL=$(grep client_email $GCE_PEM_PATH | sed -e 's/  "client_email": "//g' -e 's/",//g')

# Setup gcloud
gcloud auth activate-service-account --key-file $GCE_PEM_PATH
gcloud config set project $GCLOUD_PROJECT
gcloud config set compute/region $GCLOUD_REGION
gcloud config set compute/zone $GCLOUD_ZONE
