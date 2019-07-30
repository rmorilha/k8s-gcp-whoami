FROM python:2.7-alpine

ENV TERRAFORM_VERSION=0.12.5 \
    GCLOUD_SDK_VERSION=255.0.0 \
    CFSSL_VERSION=R1.2 \
    KUBE_VERSION=v1.12.2  
## Need to be v13 or lower (Initializers update on v14 goes wrong)

ENV GCLOUD_SDK_FILE=google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    TERRAFORM_FILE=terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN apk update && \
    apk add bash curl git openssh-client gcc make musl-dev libffi-dev openssl-dev && \
    curl -o /opt/$GCLOUD_SDK_FILE https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$GCLOUD_SDK_FILE && \
    curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/$CFSSL_VERSION/cfssl_linux-amd64 && \
    curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/$CFSSL_VERSION/cfssljson_linux-amd64 && \
    curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl && \
    curl -o /usr/local/bin/kubeadm https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubeadm && \
    curl -o /opt/$TERRAFORM_FILE https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILE

WORKDIR /opt

RUN unzip $TERRAFORM_FILE && \
    mv terraform /usr/local/bin && \
    rm $TERRAFORM_FILE && \
    tar xzf $GCLOUD_SDK_FILE && \
    /opt/google-cloud-sdk/install.sh -q && \
    ln -s /opt/google-cloud-sdk/bin/gcloud /usr/bin/gcloud && \
    /opt/google-cloud-sdk/bin/gcloud config set disable_usage_reporting true && \
    rm /opt/${GCLOUD_SDK_FILE} && \
    chmod +x /usr/local/bin/cfssl* /usr/local/bin/kubectl /usr/local/bin/kubeadm && \
    pip2 install ansible

ADD profile /root/.bashrc
ADD ansible.cfg /root/.ansible.cfg

WORKDIR /opt/app

ENTRYPOINT [ "/bin/bash" ]

