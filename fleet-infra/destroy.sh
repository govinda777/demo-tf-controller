docker system prune -y
docker volume prune -y

minikube delete --profile flux
