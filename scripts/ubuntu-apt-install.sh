#!/usr/bin/env bash

set -e

sudo apt update
sudo apt dist-upgrade -y

sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt install neovim

sudo apt install git zsh fzf htop

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install i3-gaps i3blocks

sudo apt install gimp
sudo apt install libncurses5
sudo apt install python-is-python3
sudo apt install pavucontrol
sudo apt install pavucontrol
sudo apt install ripgrep fd-find
sudo apt install tree
sudo apt install meld
sudo apt install clangd
