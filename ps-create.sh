#!/usr/bin/env bash
DOMAIN=cje.dmartin-cje.com
name=cb-ps-team
region=us-central1
gcloud container clusters create $name --region=$region  --machine-type=n1-standard-4 --num-nodes=2  --enable-autoscaling --min-nodes 1 --max-nodes 4 --enable-basic-auth
kubectl create clusterrolebinding cluster-admin-binding  --clusterrole cluster-admin  --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
#gcloud beta compute ssl-certificates create $name --domains $DOMAIN

#Create new node groupe
#gcloud container node-pools create node-pool-1 --cluster=$name --machine-type=n1-standard-4 --num-nodes=1  --enable-autoscaling --min-nodes 1 --max-nodes 3 --enable-autoupgrade --region=$region
