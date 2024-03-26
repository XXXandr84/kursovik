#!/bin/sh
sleep 1
cd ./Apps/
kubectl apply -f rabbitmq-service.yml
sleep 1
kubectl apply -f mongo-service.yml
sleep 1
kubectl apply -f search-crawler-deployment.yml
sleep 1
kubectl apply -f search-crawler-mongodb-service.yml
sleep 1
kubectl apply -f search-crawler-rabbitmq-service.yml
sleep 1
kubectl apply -f search-ui-mongodb-service.yml
sleep 1
kubectl apply -f search-ui-service.yml
sleep 1
kubectl apply -f mongo-deployment.yml
sleep 1
kubectl apply -f rabbitmq-deployment.yml
sleep 1
kubectl apply -f search-ui-deployment.yml
sleep 1
kubectl apply -f fluent.yaml
sleep 1
kubectl apply -f dashboard.yml
sleep 1
echo kubectl apply -f ui-ingress.yml
sleep 1
kubectl apply -f tiller.yml
sleep 20
echo kubectl get services
kubectl get services
echo kubectl get pods
kubectl get pods
echo kubectl get ingress
kubectl get ingress
exit