# Use a Jenkins LTS official image as a base
FROM jenkins/jenkins:lts

# (Optional) Install Docker to run Docker commands inside Jenkins
USER root
RUN apt-get update && \
    apt-get -y install apt-transport-https \
                       ca-certificates \
                       curl \
                       gnupg2 \
                       software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io && \
    usermod -aG docker jenkins && \
    newgrp docker

# Drop back to the regular jenkins user
USER jenkins

# Inform Docker that Jenkins will run on port 8080
EXPOSE 8080

# Start Jenkins server as the default command
CMD ["jenkins.sh"]
