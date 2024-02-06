source .env

minikube start  --profile flux --driver=docker

arch -arm64 brew install fluxcd/tap/flux

flux check --pre

kubectl config current-context

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=demo-tf-controller \
  --branch=main \
  --path=./flux_tf_controller/clusters/my-cluster \
  --timeout=90m \
  --personal \
  --components-extra image-reflector-controller,image-automation-controller

kubectl create secret generic aws-credentials \
--namespace=flux-system \
--from-literal=AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
--from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

kubectl config current-context

# Config UI

arch -arm64 brew tap weaveworks/tap
arch -arm64 brew install weaveworks/tap/gitops

export PASSWORD="hermes1"
gitops create dashboard ww-gitops \
  --password=$PASSWORD \
  --export > ./clusters/my-cluster/weave-gitops-dashboard.yaml

kubectl get pods -n flux-system

