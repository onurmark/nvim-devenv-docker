# nvim-devenv-docker
Develop environment for c programmer with Neovim on docker

# Use devenv

## Docker build image

```
docker build -t nvim-devenv-docker:1.0 --build-arg USERNAME=$(USER) .
```

## Run container

### Quick launch container

```
docker run --it -d --name devenv \
  nvim-devenv-docker:1.0
```

### Launch container with volumn

```
docker volumn create devenv-volumn
docker run --it -d --name devenv \
  -v devenv-volumn:/home/$(USER}/Workspaces \
  nvim-devenv-docker:1.0
```

### Launch container with tftpd-hpa

```
docker run --it -d --name devenv \
  -v devenv-volumn:/home/$(USER}/Workspaces \
  -p 69:69/udp \
  nvim-devenv-docker:1.0
```

## Use devenv container

```
docker exec -it devenv zsh
```
