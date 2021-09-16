#!/usr/bin/env bash

set -e

sudo apt update
sudo apt dist-upgrade -y

sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt install neovim

sudo apt install git zsh fzf

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install i3-gaps i3blocks
