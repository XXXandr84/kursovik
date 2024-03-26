#!/bin/bash
echo "Creating k8s cluster. Sleep 5 seconds"
sleep 5
cd ./terraform/
terraform apply --auto-approve=true
exit

