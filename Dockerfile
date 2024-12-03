# Use the official Jenkins LTS image
FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install Docker and other necessary packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    sudo

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Add Jenkins user to the Docker group

RUN usermod -aG $(getent group 999 | cut -d: -f1) jenkins

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins default port
EXPOSE 8080

# Use bash shell instead of sh
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/jenkins.sh"]
