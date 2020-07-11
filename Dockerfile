FROM gitlab/gitlab-runner:latest
RUN apt update && apt -y install gzip wget jq openssh-client && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget -O - https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gzip -d > /usr/local/bin/govc && \
	chmod +x /usr/local/bin/govc

WORKDIR /opt/vc
COPY ./src ./src

ENV GOVC_USERNAME administrator@example.com
ENV GOVC_PASSWORD pass_here
ENV GOVC_URL vc.example.com
ENV VC_DATACENTER example
ENV VC_HOST esxi.example.com
ENV VC_RESOURCE_POOL runners
ENV VC_DATASTORE example-datastore1
ENV VC_NETWORK example-network
ENV VC_TEMPLATE runner-template-debian
ENV VC_CPUS 2
ENV VC_MEMS 4096
ENV VC_SSH_USER root
ENV VC_SHELL /bin/bash
