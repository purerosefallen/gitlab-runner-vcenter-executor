#!/usr/bin/env bash

# /opt/vc/cleanup.sh

currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${currentDir}/base # Get variables from base script.

set -eo pipefail

# Destroy VM.
govc vm.destroy "-dc=$DATACENTER" "$VM_ID"
