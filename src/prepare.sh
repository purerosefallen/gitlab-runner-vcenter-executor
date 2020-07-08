#!/usr/bin/env bash

# /opt/vc/src/prepare.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base # Get variables from base script.

set -eo pipefail

# trap any error, and mark it as a system failure.
trap "exit $SYSTEM_FAILURE_EXIT_CODE" ERR

# Install the VM
govc vm.clone "-dc=$VC_DATACENTER" -on=true -waitip=true "-vm=$VC_TEMPLATE" "-host=$VC_HOST" "-pool=$VC_RESOURCE_POOL" "-ds=$VC_DATASTORE" "-net=$VC_NETWORK" "-c=$VC_CPUS" "-m=$VC_MEMS" "$VM_ID"

# Wait for VM to get IP
echo 'Waiting for VM to get IP'
for i in $(seq 1 30); do
    VM_IP=$(_get_vm_ip)

    if [ -n "$VM_IP" ]; then
        echo "VM got IP: $VM_IP"
        break
    fi

    if [ "$i" == "30" ]; then
        echo 'Waited 30 seconds for VM to start, exiting...'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1s
done

# Wait for ssh to become available
echo "Waiting for sshd to be available"
for i in $(seq 1 30); do
    if ssh -i "${currentDir}/../ssh/id_rsa" -o StrictHostKeyChecking=no "$VC_SSH_USER@$VM_IP" >/dev/null 2>/dev/null; then
        break
    fi

    if [ "$i" == "30" ]; then
        echo 'Waited 30 seconds for sshd to start, exiting...'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1s
done
