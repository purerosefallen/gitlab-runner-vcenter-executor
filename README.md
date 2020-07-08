# GitLab runner vCenter executor

Gitlab vCenter executor based on `govc`.

## How to use

This Docker image works as the usual GitLab runner, but added a vCenter executor working as custom executor.

The related scripts are located at `/opt/vc/src` .

## Example config.toml file

Displays `runners.custom` session only.

```ini
  [runners.custom]
    prepare_exec = "/opt/vc/src/prepare.sh" # Path to a bash script to create VM.
    run_exec = "/opt/vc/src/run.sh" # Path to a bash script to run script inside of VM over ssh.
    cleanup_exec = "/opt/vc/src/cleanup.sh" # Path to a bash script to delete VM and disks.
```

# Volumes

* `/opt/vc/ssh/id_rsa` The SSH private key used for SSHing into the worker VMs.

# Environment variables

```Dockerfile
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
```
