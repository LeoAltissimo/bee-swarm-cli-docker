FROM ubuntu:latest

ENV BEE_VERSION=1.8.0
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
RUN curl -fsSL https://repo.ethswarm.org/apt/gpg.key | gpg --dearmor -o /usr/share/keyrings/ethersphere-apt-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ethersphere-apt-keyring.gpg] https://repo.ethswarm.org/apt * *" | tee /etc/apt/sources.list.d/ethersphere.list > /dev/null && \
    apt-get update -y && \
    while lsof /var/lib/dpkg/lock-frontend ; do sleep 1; done; \
    apt-get install bee -y

# Copying Bee configuration file
RUN /bin/bash -c ". $NVM_DIR/nvm.sh && mkdir -p /etc/bee && npx bee-yaml > /etc/bee/bee.yaml"


# Exposing SSH and Bee ports
EXPOSE 22 1633 1634 1635

COPY --chmod=755 scripts/* .

CMD ["./start.sh"]