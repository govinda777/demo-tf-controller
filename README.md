# tf-controller
POC - TF Controller + Lambda + Api GW

1 - Instal minikube

arch -arm64 /bin/bash -c "$(curl -fsSL <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)">

arch -arm64 brew install minikube

2 - Start minikube

minikube start

3 - Install kubectl

4 - Install kind

brew install kind


5 - Instalar Flux

brew install fluxcd/tap/flux

6 - Configure seus acessos

export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

Libere acesso a Push e Pull no seu repositório

7 - Verifique se o Flux está configurado corretamente

flux check --pre

8 - Instale o Flux em seu cluster

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fleet-infra \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal \
  --components-extra image-reflector-controller,image-automation-controller


9 - Instale o GitOps

brew tap weaveworks/tap
brew install weaveworks/tap/gitops

10 - Crie  HelmRepository and HelmRelease to deploy Weave GitOps

PASSWORD="hermes1"
gitops create dashboard ww-gitops \
  --password=$PASSWORD \
  --export > ./clusters/my-cluster/weave-gitops-dashboard.yaml

11 - Suba as alteracoes

git add -A && git commit -m "Add Weave GitOps Dashboard"
git push

12 - Veja os pods em execucao

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

13 - Acessa a UI

kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001

user admin
password hermes1

http://localhost:9001/

14 - Configure sua chave AWS no cluster

kubectl create secret generic tf-aws-keys \
-n flux-system \
--from-literal=access_key=$AWS_ACESS_KEI_ID \
--from-literal=secret_key=$AWS_SECRET_ACESS_KEY

15 - Instale o TF Controller no cluster



16 - Atach repository IAC terraform files

