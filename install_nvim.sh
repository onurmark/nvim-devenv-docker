#!/bin/bash

ARCH=`uname -i`

if [ x"x86_64" = x"$ARCH" ]; then
  echo "OS Linux detected "
  mv /tmp/nvim-amd64.appimage /tmp/nvim.appimage
elif [ x"aarch64" = x"$ARCH" ]; then
  echo "Mac"
  mv /tmp/nvim-aarch64.appimage /tmp/nvim.appimage
fi

chmod u+x /tmp/nvim.appimage
/tmp/nvim.appimage --appimage-extract
ln -s /squashfs-root/AppRun /usr/bin/vi
