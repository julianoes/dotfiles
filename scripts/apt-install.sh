#!/usr/bin/env bash

set -e

sudo apt update
sudo apt dist-upgrade -y

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
    colordiff
