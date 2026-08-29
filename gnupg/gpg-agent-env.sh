# Use the YubiKey's GPG agent as the SSH agent.
#
# Sourced from both ~/.profile and ~/.zshrc. zsh never reads ~/.profile -
# there is no ~/.zprofile and ~/.zshenv only sets up cargo - so neither file
# can rely on the other having run, and the setup has to live somewhere both
# can reach.

SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AUTH_SOCK

# Only meaningful on a terminal; a graphical login has no tty. Set before
# updatestartuptty below, which is what hands the running agent the tty to
# prompt on - the old ordering exported GPG_TTY afterwards, too late to be
# picked up.
if [ -t 0 ]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

gpgconf --launch gpg-agent >/dev/null 2>&1
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
