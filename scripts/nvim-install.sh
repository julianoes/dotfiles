#!/usr/bin/env bash
set -e

vim +PlugInstall +qall
cd ~/.local/share/nvimplugged/coc.nvim
yarn install
yarn build

vim +CocInstall coc-clangd +qall

