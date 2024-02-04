# demo-tf-controller
POC - TF Controller + Lambda + Api GW

## pré requisitos

- minikube
- kubectl
- kind
- flux

1 - Instal minikube


```bash
arch -arm64 /bin/bash -c "$(curl -fsSL <https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)">

arch -arm64 brew install minikube
```


2 - Start minikube

```bash
minikube start
```

3 - Install kubectl

```bash

```

4 - Install kind

```bash
brew install kind
```

5 - Instalar Flux

```bash
brew install fluxcd/tap/flux
```

6 - Configure seus acessos

```bash
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>

#Libere acesso a Push e Pull no seu repositório
```

7 - Verifique se o Flux está configurado corretamente

```bash
flux check --pre
```

8 - Instale o Flux em seu cluster

```bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fleet-infra \
  --branch=main \
  --path=./flux_tf_controller/clusters/my-cluster \
  --personal \
  --components-extra image-reflector-controller,image-automation-controller

```

9 - Instale o GitOps

```bash
brew tap weaveworks/tap
brew install weaveworks/tap/gitops
```

10 - Crie  HelmRepository and HelmRelease to deploy Weave GitOps


```bash
PASSWORD="hermes1"
gitops create dashboard ww-gitops \
  --password=$PASSWORD \
  --export > ./clusters/my-cluster/weave-gitops-dashboard.yaml
```

11 - Suba as alteracoes


```bash
git add -A && git commit -m "Add Weave GitOps Dashboard"
git push
```

12 - Veja os pods em execucao

```bash
kubectl get pods -n flux-system

➜ demo-tf-controller (main) ✔ kubectl get pods -n flux-system
NAME                                           READY   STATUS    RESTARTS   AGE
helm-controller-865448769d-7pzgj               1/1     Running   0          11m
image-automation-controller-69b75845c5-kqjmd   1/1     Running   0          11m
image-reflector-controller-84f896568c-4pjvz    1/1     Running   0          11m
kustomize-controller-5c8878fd86-xx9v7          1/1     Running   0          11m
notification-controller-59696fbb58-6rbhr       1/1     Running   0          11m
source-controller-fc5555fb-p9fxx               1/1     Running   0          11m
ww-gitops-weave-gitops-9c86dc9f-dhk55          1/1     Running   0          93s
➜ demo-tf-controller (main) ✔ 

```

13 - Acessa a UI

```bash

kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001

user admin
password hermes1

http://localhost:9001/

```

14 - Configure sua chave AWS no cluster

```bash
kubectl create secret generic tf-aws-keys \
-n flux-system \
--from-literal=access_key=$AWS_ACESS_KEI_ID \
--from-literal=secret_key=$AWS_SECRET_ACESS_KEY
```

15 - Atach repository IAC terraform files

gitrepositories/iac-instance-ec2_repo.yaml

```bash

apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: iac-instance-ec2
  namespace: flux-system
spec:
  interval: 30s
  ref:
    branch: main
  url: https://github.com/govinda777/iac_instance_ec2

```

iac-instance-ec2_terraform.yaml

```bash

apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: iac-instance-ec2
  namespace: flux-system
spec:
  path: ./
  approvePlan: auto
  destroyResourcesOnDeletion: true
  interval: 30s
  sourceRef:
    kind: GitRepository
    name: iac-instance-ec2
  runnerPodTemplate:
    spec:
      envFrom:
      - secretRef:
          name: aws-credentials

```

tfctl reconcile terraform <nome-do-recurso>
