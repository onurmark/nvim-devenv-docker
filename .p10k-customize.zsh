function prompt_docker_host() {
  if [[ ! -z "$DOCKER_MACHINE_NAME" ]]; then
    p10k segment -f red -t "$DOCKER_MACHINE_NAME"
  fi
}

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[${#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS}-1,0]=docker_host
