#!/usr/bin/env bash
DOMAIN=cje.dmartin-cje.com
name=partners-cje
region=us-central1
gcloud container clusters create $name --region=$region  --machine-type=n1-standard-2 --num-nodes=1  --enable-autoscaling --min-nodes 1 --max-nodes 1
kubectl create clusterrolebinding cluster-admin-binding  --clusterrole cluster-admin  --user $(gcloud config get-value account)
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl apply -f ../yaml_files/ssd-storage.yaml
helm init --service-account tiller
kubectl apply -f ../yaml_files/rbac-config.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
#gcloud beta compute ssl-certificates create $name --domains $DOMAIN
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
helm install --name cert-manager --namespace kube-system --version v0.6.0 stable/cert-manager --set webhook.enabled=false 
#gcloud iam service-accounts create clouddns --display-name=clouddns --project cje20-200714
gcloud iam service-accounts keys create ./clouddns.key.json --iam-account=clouddns@cje20-200714.iam.gserviceaccount.com --project=cje20-200714
gcloud projects add-iam-policy-binding  cje20-200714 --member=serviceAccount:clouddns@cje20-200714.iam.gserviceaccount.com --role=roles/dns.admin
kubectl create secret generic clouddns --from-file=./clouddns.key.json  --namespace=kube-system
kubectl apply -f ../yaml_files/cluster-issuer.yaml 


#Create new node groupe
#gcloud container node-pools create node-pool-1 --cluster=$name --node-labels workload=build --node-taints nodeType=build:NoSchedule --machine-type=n1-standard-4 --num-nodes=1  --enable-autoscaling --min-nodes 1 --max-nodes 3 --enable-autoupgrade --region=$region

