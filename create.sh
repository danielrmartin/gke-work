!# /bin/bash
set DOMAIN=cje.dmartin-cje.com
set cluster-name=dmartin-cje
gcloud container clusters create $cluster-name --zone us-central1-a,us-central1-b --machine-type=n1-standard-8 --num-nodes=2
kubectl create clusterrolebinding cluster-admin-binding  --clusterrole cluster-admin  --user $(gcloud config get-value account)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
gcloud beta compute ssl-certificates create $cluster-name --domains $DOMAIN 
