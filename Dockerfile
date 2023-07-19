FROM ubuntu:latest

LABEL "maintainer"="onurmark@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

ARG USERNAME=john
ENV USER $USERNAME

RUN apt-get update

RUN apt-get install -y \
      zsh gcc g++ gdb git automake autoconf curl wget \
      sudo libtool make zip bear ripgrep libfuse-dev

# Locale
RUN apt-get install -y locales
RUN locale-gen ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# Timezone
RUN apt-get install -yq tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata
ENV TZ="Asia/Seoul"

# Install NVIM
RUN curl -fLo /tmp/nvim-amd64.appimage --create-dirs \
      https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
ADD ./nvim-v0.9.1-aarch64.appimage /tmp/nvim.appimage
ADD ./install_nvim.sh /tmp/install_nvim.sh
RUN bash /tmp/install_nvim.sh

# Install tftpd-hpa
RUN apt install -y tftpd-hpa
RUN mkdir -p /tftpboot/$USER
RUN chown -R root:tftp /tftpboot
RUN chmod -R g+w /tftpboot

RUN sed -i'' -e "s/^\(TFTP_DIRECTORY\s*=\s*\).*\$/\1\"\/tftpboot\"/" \
      /etc/default/tftpd-hpa
RUN sed -i'' -e "s/^\(TFTP_OPTIONS\s*=\s*\).*\$/\1\"--secure --create\"/" \
      /etc/default/tftpd-hpa

EXPOSE 69/udp

RUN useradd -ms /bin/zsh $USER
RUN usermod -aG sudo $USER
RUN usermod -aG tftp $USER
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

# Install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN sed -i.bak \
  's~\(ZSH_THEME="\)[^"]*\(".*\)~\1powerlevel10k\/powerlevel10k\2~' \
  ~/.zshrc

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install --key-bindings --completion --update-rc

# Install Neovim config
RUN git clone --depth 1 https://github.com/onurmark/dotfiles.git /tmp/dotfiles
RUN cp -rf /tmp/dotfiles/.config ~

# Generate ssh
RUN ssh-keygen -q -t rsa -N '' -f /home/$USER/.ssh/id_rsa

RUN mkdir -p ~/Workspaces

ADD entry-point.sh /
ENTRYPOINT ["/entry-point.sh"]

