
../flux_tf_controller/apply.sh

# Start UI Flux TF Controller

kubectl port-forward svc/ww-gitops-weave-gitops -n flux-system 9001:9001;

# 