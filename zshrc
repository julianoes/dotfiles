ZSH=$HOME/.ohmyzsh
plugins=(git vi-mode)
ZSH_THEME="mortalscumbag"
source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color
export GIT_SUBMODULES_ARE_EVIL=1 # For PX4
export PX4_NO_FOLLOW_MODE=1
export EDITOR=vim

alias vim='vim_with_line'
vim_with_line() {
   if [[ $1 =~ ^(.*):([0-9]+)$ ]]; then
       command vim "+$match[2]" "$match[1]"
   else
       command vim "$@"
   fi
}

alias gdc='git diff --cached'
alias gdt='git difftool -d'
alias gdtc='git difftool -d --cached'
alias gsuir="git submodule update --init --recursive"
alias gssr="git submodule sync --recursive"

alias fd="fdfind"
alias fdi="fdfind --no-ignore"

alias rgi="rg --no-ignore"

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Use Yubikey GPG for SSH
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye > /dev/null
export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fnm
export PATH="/home/julianoes/.local/share/fnm:$PATH"
eval "`fnm env`"

# Fix Gazebo scale


# dotfiles scripts
export PATH="$PATH:/home/julianoes/dotfiles/local/bin"

export PATH=$PATH:/home/julianoes/.local/share/gem/ruby/3.2.0/bin
