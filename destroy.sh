#!/bin/bash
echo "Destroy k8s cluster!!!! Sleep 10 seconds"
sleep 10
cd ./terraform/
terraform destroy --auto-approve=true

