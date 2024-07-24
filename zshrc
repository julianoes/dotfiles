ZSH=$HOME/.ohmyzsh
plugins=(git vi-mode)
ZSH_THEME="mortalscumbag"
source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color
export GIT_SUBMODULES_ARE_EVIL=1 # For PX4
export PX4_NO_FOLLOW_MODE=1
export EDITOR=nvim

alias gdc='git diff --cached'
alias gdt='git difftool -d'
alias gdtc='git difftool -d --cached'
alias gsuir="git submodule update --init --recursive"
alias gssr="git submodule sync --recursive"

alias fd="fdfind"
alias fdi="fdfind --no-ignore"

alias rgi="rg --no-ignore"

alias vim="nvim"

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/software/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"

export ANDROID_SDK_ROOT=$HOME/Android/Sdk

# Use Yubikey GPG for SSH
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
export PATH="/home/julianoes/.local/share/fnm:$PATH"
eval "`fnm env`"

