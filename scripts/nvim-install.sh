#!/usr/bin/env bash

set -e

sudo curl -L -o /opt/nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo chmod +x /opt/nvim.appimage
sudo ln -s -f /opt/nvim.appimage /usr/local/bin/nvim
