# Kubernetes on Google Computing Engine

This project leverages hype tools (terraform, ansible, docker, ...) 
to automate the deployment of a 6 vms (3 controllers, 3 workers‍) 
kubernetes cluster on GCE.

## How to use

- Put your `keys.json` in the `app` dir (See [Gcloud account](#gcloud-account) for details on this file) .
- Adapt `profile` to match your desired region, zone and project
- Launch `./start_tools.sh`, it will build a docker image and launch a container with
all needed tools (kubectl, kubeadm, gcloud....)
- In the container, launch `./create.sh` and wait for ~15mins
- Onde finished, access any of your workers IP on port 80 /whoami (maybe you'll get some gateway timeout on the very beginning)
- And you're done !

When you finish, launch `./cleanup.sh` to remove all gce resources and other files that installation creates.

## Gcloud account 

To interact with Gcloud API we use a service account. 
The `keys.json` is your service account key file.
You can find more infos on how to setup a service account 
[here](https://cloud.google.com/video-intelligence/docs/common/auth#set_up_a_service_account).

## Addons

### Traefik ingress

- Go to 13-addons dir: `cd 13-addons`
- Launch `./deploy-traefik.sh`, this will create the cluster role needed for traefik, the traefik daemonset and the firewall rule to enable trafic in

### Tests

- Go to 14-whoami dir: `cd 14-whoami`
- Deploy whoami app example: `./setup-whoami.sh`

## Credits 👍

This work is an automation of [kubernetes-the-easy-way](https://github.com/Zenika/k8s-on-gce)
