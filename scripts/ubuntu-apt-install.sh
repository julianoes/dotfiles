#!/usr/bin/env bash

set -e

sudo apt update
sudo apt dist-upgrade -y

#sudo add-apt-repository --yes ppa:neovim-ppa/unstable

echo "deb http://ppa.launchpad.net/neovim-ppa/stable/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/neovim.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 9DBB0BE9366964F134855E2255F96FCF8231B6DD
sudo apt update

sudo apt install -y neovim
sudo apt install -y xclip

sudo apt install -y git zsh fzf htop

#sudo add-apt-repository ppa:regolith-linux/release
sudo apt install -y i3 i3blocks

sudo apt install -y gimp
sudo apt install -y libncurses5
sudo apt install -y python-is-python3 python3-pip
sudo apt install -y pavucontrol
sudo apt install -y ripgrep fd-find
sudo apt install -y tree
sudo apt install -y meld
sudo apt install -y clangd

sudo apt install curl
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

sudo apt install -y build-essential cmake gdb systemd-coredumpctl
sudo apt install -y feh
sudo apt install -y dtrx
