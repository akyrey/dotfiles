#!/bin/bash
set -e

tags="$*"

if [ -z "$tags" ]; then
  tags="all"
fi

if ! [ -x "$(command -v ansible)" ]; then
  if ! [ -x "$(command -v python3 -m pip)" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py
  fi
  python3 -m pip install ansible
  ansible-galaxy collection install community.general
  ansible-galaxy collection install ansible.posix
  ansible-galaxy collection install kewlfft.aur
fi

cmd="ansible-playbook -i ~/.dotfiles/hosts ~/.dotfiles/dotfiles.yml"

if [[ "$tags" == *"k8s"* || "$tags" == "all" ]]; then
  cmd="$cmd --vault-id k8s@prompt"
fi

if [[ "$tags" == *"scripts"* || "$tags" == "all" ]]; then
  cmd="$cmd --vault-id intelephense@prompt"
fi

if [[ "$tags" == *"ssh"* || "$tags" == "all" ]]; then
  cmd="$cmd --vault-id ssh@prompt"
fi

if [[ "$tags" == *"wakatime"* || "$tags" == "all" ]]; then
  cmd="$cmd --vault-id wakatime@prompt"
fi

eval "$cmd --ask-become-pass --tags $tags"

if command -v terminal-notifier 1>/dev/null 2>&1; then
  terminal-notifier -title "dotfiles: Bootstrap complete" -message "Successfully set up dev environment."
fi
