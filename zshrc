ZSH=$HOME/.ohmyzsh
plugins=(git vi-mode)
ZSH_THEME="mortalscumbag"
source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color
export GIT_SUBMODULES_ARE_EVIL=1 # For PX4
export EDITOR=nvim

alias gdc='git diff --cached'
alias gdt='git difftool -d'
alias gdtc='git difftool -d --cached'
alias gsuir="git submodule update --init --recursive"
alias gssr="git submodule sync --recursive"

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
