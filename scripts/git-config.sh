#!/usr/bin/env bash

git config --global user.name "Julian Oes"
git config --global user.email "julian@oes.ch"

# from: https://coderwall.com/p/euwpig/a-better-git-log

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# more colors:

git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto

git config --global --add difftool.prompt false
git config --global diff.tool meld

git config --global core.excludesfile '~/.global_gitignore'

git config --global core.editor "nvim"
git config --global push.default simple

# Always use git access instead of https for GitHub
git config --global url."git@github.com:".insteadof "https://github.com/"
