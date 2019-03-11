#!/usr/bin/env bash
DOMAIN=cje.dmartin-cje.com
name=dmartin-cje
gcloud container clusters create $name --region us-central1 --machine-type=n1-standard-2 --num-nodes=2
kubectl create clusterrolebinding cluster-admin-binding  --clusterrole cluster-admin  --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
#gcloud beta compute ssl-certificates create $name --domains $DOMAIN 
