# bee-swarm-cli-docker
Latitude.sh Launchpad blueprint for Bee and swarm cli

[Blueprint link](https://latitude.sh/blueprint/1cnxvazdFwuBm5vWtab0Bg)

## Environment Variables

Each of the following environment variable is optional, set either `SSH_PASSWORD` or `PUBLIC_KEY` for ssh access

| Variable     | Description                             |
| ------------ | --------------------------------------- |
| PUBLIC_KEY   | Public Key for ssh access               |
| SSH_USER     | Username for ssh access (default: root) |

### SSH access

To enable SSH access, enter your public SSH key in the `PUBLIC_KEY` environment variable during deployment. After deployment, use the provided IP address and the following command to connect:

```
ssh root@<APP_IP> -p 22
```

### Building the docker image
```bash
git clone https://github.com/LeoAltissimo/bee-swarm-cli-docker.git
cd bee-swarm-cli-docker
docker build build latest
```