#!/usr/bin/env bash

languages=`echo "lua typescript nodejs php" | tr ' ' '\n'`
core_utils=`echo "xargs find mv sed awk ls zip" | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter query: " query

if printf "$languages" | grep -qs "$selected"; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "curl cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
fi
