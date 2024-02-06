# fleet-infra

TODO : 

## Como usar a UI

kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001;

## 

export GITHUB_TOKEN=<YOUR_GITHUB_TOKEN_PAT>

export GITHUB_USER=<YOUR_GITHUB_USER>

export AWS_ACESS_KEI_ID=<YOUR_AWS_ACESS_KEI_ID>

export AWS_SECRET_ACESS_KEY=<YOUR_AWS_SECRET_ACESS_KEY>


flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fleet-infra \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal \
  --components-extra image-reflector-controller,image-automation-controller

## How to enable UI 

- Instale o GitOps

brew tap weaveworks/tap
brew install weaveworks/tap/gitops

- Crie  HelmRepository and HelmRelease to deploy Weave GitOps

export PASSWORD="hermes1"
gitops create dashboard ww-gitops \
  --password=$PASSWORD \
  --export > ./clusters/my-cluster/weave-gitops-dashboard.yaml

- Suba as alteracoes

git add -A && git commit -m "Add Weave GitOps Dashboard"
git push

- Veja os pods em execucao

kubectl get pods -n flux-system

➜ fleet-infra (main) ✔ kubectl get pods -n flux-system
NAME                                           READY   STATUS    RESTARTS   AGE
helm-controller-865448769d-7pzgj               1/1     Running   0          11m
image-automation-controller-69b75845c5-kqjmd   1/1     Running   0          11m
image-reflector-controller-84f896568c-4pjvz    1/1     Running   0          11m
kustomize-controller-5c8878fd86-xx9v7          1/1     Running   0          11m
notification-controller-59696fbb58-6rbhr       1/1     Running   0          11m
source-controller-fc5555fb-p9fxx               1/1     Running   0          11m
ww-gitops-weave-gitops-9c86dc9f-dhk55          1/1     Running   0          93s
➜ fleet-infra (main) ✔ 

- Acessa a UI

kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001

user admin
password hermes1

http://localhost:9001/

## Apply & Destroy

chmod +x destroy.sh
chmod +x apply.sh

## Como forçar um reconcile

flux reconcile source git flux-system


## Manual apply

kubectl apply -f aws-credentials.yaml -n flux-system
kubectl apply -f iac-instance-ec2_repo.yaml -n flux-system
kubectl apply -f iac-instance-ec2_terraform.yaml -n flux-system

kubectl delete pod iac-instance-ec2-tf-runner -n flux-system