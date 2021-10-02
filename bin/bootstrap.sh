#!/bin/bash
set -e

tags="$1"

if [ -z $tags ]; then
  tags="all"
fi

if ! [ -x "$(command -v ansible)" ]; then
  if ! [ -x "$(command -v python3 -m pip)" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    rm get-pip.py
  fi
  python3 -m pip install --user ansible
  ansible-galaxy collection install community.general
  ansible-galaxy collection install ansible.posix
fi

ansible-playbook -i ~/.dotfiles/hosts ~/.dotfiles/dotfiles.yml --vault-id ssh@prompt --ask-become-pass --tags $tags

if command -v terminal-notifier 1>/dev/null 2>&1; then
  terminal-notifier -title "dotfiles: Bootstrap complete" -message "Successfully set up dev environment."
fi
