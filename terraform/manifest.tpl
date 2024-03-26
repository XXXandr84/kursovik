#!/bin/bash
echo "run apps"
sleep 5
cd ./terraform/
ssh ubuntu@${addrs[0]} ./script2.sh
