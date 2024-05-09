#!/usr/bin/env bash

set -e

sudo apt update
sudo apt upgrade -y

sudo apt purge -y pcscd

sudo apt install -y \
    neovim \
    xclip \
    git \
    zsh \
    fzf \
    htop \
    ripgrep \
    fd-find \
    tree \
    meld \
    build-essential \
    cmake \
    clangd \
    curl \
    dtrx \
    colordiff \
    pinentry-gnome3
