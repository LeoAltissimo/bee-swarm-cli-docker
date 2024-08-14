FROM ubuntu:latest

ENV NVM_DIR=/root/.nvm

# Updating and installing dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    jq \
    tar \
    gnupg \
    openssh-server \
    sudo \
    build-essential \
    systemctl

# Creating directory for SSH service
RUN mkdir /var/run/sshd

# Configuring SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Installing nvm, Node.js, and Swarm-CLI
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 20 && \
    npm install --global @ethersphere/swarm-cli

# Installing Bee
RUN curl -s https://raw.githubusercontent.com/ethersphere/bee/master/install.sh | bash

# Copying Bee configuration file
RUN /bin/bash -c ". $NVM_DIR/nvm.sh && mkdir -p /etc/bee && npx bee-yaml > /etc/bee/bee.yaml"


# Exposing SSH and Bee ports
EXPOSE 22 1633 1634

COPY --chmod=755 scripts/* .

CMD ["./start.sh"]