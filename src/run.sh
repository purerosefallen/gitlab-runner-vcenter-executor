#!/usr/bin/env bash

# /opt/vc/run.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base # Get variables from base script.

VM_IP=$(_get_vm_ip)

ssh -i "${currentDir}/../ssh/id_rsa" -o StrictHostKeyChecking=no "$VC_SSH_USER@$VM_IP" /bin/bash < "${1}"
if [ $? -ne 0 ]; then
    # Exit using the variable, to make the build as failure in GitLab
    # CI.
    exit "$BUILD_FAILURE_EXIT_CODE"
fi
