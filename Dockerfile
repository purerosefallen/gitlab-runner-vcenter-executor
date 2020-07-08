FROM gitlab/gitlab-runner:latest
RUN apt update && apt -y install gzip wget jq openssh-client && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN wget -O - https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gzip -d > /usr/local/bin/govc && \
	chmod +x /usr/local/bin/govc

WORKDIR /opt/vc
COPY ./src ./
