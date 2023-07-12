# nvim-devenv-docker
Develope environment for c programmer with Neovim on docker

# Docker build
docker build -t nvim-devenv-docker:1.0 --build-arg USERNAME=$(USER) .

# Run container
docker run --it -d --name devenv nvim-devenv-docker:1.0

# Run container with volumn
docker volumn create devenv-volumn
docker run --it -d --name devenv -v devenv-volumn:/home/$(USER}/Workspaces nvim-devenv-docker:1.0

# Use devenv container
docker exec -it devenv zsh
