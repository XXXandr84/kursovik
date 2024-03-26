#!/bin/sh
sleep 2
cd ./Apps/
kubectl apply -f rabbitmq-service.yml
sleep 2
kubectl apply -f mongo-service.yml
sleep 2
kubectl apply -f search-crawler-deployment.yml
sleep 2
kubectl apply -f search-crawler-mongodb-service.yml
sleep 2
kubectl apply -f search-crawler-rabbitmq-service.yml
sleep 2
kubectl apply -f search-ui-mongodb-service.yml
sleep 2
kubectl apply -f search-ui-service.yml
sleep 2
kubectl apply -f mongo-deployment.yml
sleep 2
kubectl apply -f rabbitmq-deployment.yml
sleep 2
kubectl apply -f search-ui-deployment.yml
sleep 2
kubectl apply -f ui-ingress.yml
sleep 2
kubectl get services
exit