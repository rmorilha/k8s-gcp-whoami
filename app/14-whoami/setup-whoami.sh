#!/bin/sh

kubectl apply -f ./14-whoami/whoami-deployment.yml

## Deploying Jenkins
#kubectl create -f jenkins-deployment.yaml --namespace=kube-system
#kubectl describe deployments --namespace=kube-system

## Creating Jenkins Service
#kubectl create -f jenkins-service.yaml --namespace=kube-system
