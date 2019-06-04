#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Informe o arquivo de inventario e Extra vars \for ansible"
    echo "Exemplo ./run.sh hosts.yml -e 'tag_name=v1' "
    exit 1
fi

function title() {
    echo -e "\e[105m\e[1m$1\e[0m"
}

title ">_ vagrant up: vagrant up"
vagrant up

export ANSIBLE_STDOUT_CALLBACK=yaml

title ">_ playbook: playbook.yml"
ansible-playbook -i "$1" playbook.yml "$2" "$3"

if [ -f /usr/bin/notfy-send ]; then
    notify-send "end playbook: devops-challenge"
fi