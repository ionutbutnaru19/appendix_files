#!/bin/bash

echo "Script started running at $(date)"

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i ~/ansible/available_hosts ~/ansible/playbooks/checksum_actions.yml  --private-key=~/webserverKEY

echo "Script finished at $(date)"














