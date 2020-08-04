#!/usr/bin/env bash

# /opt/vc/src/run.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base # Get variables from base script.

for i in $(seq 1 30); do
    VM_IP=$(_get_vm_ip)

    if [[ -n "$VM_IP" && "$VM_IP" -ne "fail" ]]; then
        break
    fi

    if [ "$i" == "30" ]; then
        echo 'Waited 30 seconds for VM to get IP, exiting...'
        # Inform GitLab Runner that this is a system failure, so it
        # should be retried.
        exit "$SYSTEM_FAILURE_EXIT_CODE"
    fi

    sleep 1s
done

ssh -T -i "${currentDir}/../ssh/id_rsa" -o StrictHostKeyChecking=no "$VC_SSH_USER@$VM_IP" "$VC_SHELL" < "${1}"
if [ $? -ne 0 ]; then
    # Exit using the variable, to make the build as failure in GitLab
    # CI.
    exit "$BUILD_FAILURE_EXIT_CODE"
fi
