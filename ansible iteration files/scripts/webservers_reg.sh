#!/bin/bash


aws ec2 describe-instances --query 'Reservations[*].Instances[?Tags[?Key==`Name` && Value==`webserver`]].PrivateIpAddress' --output text > ~/ansible/hosts

known_hosts=~/ansible/hosts

if [ ! -f "$known_hosts" ]; then
    echo "Hosts file not found."
    exit 1
fi

echo "[webservers]" > ~/ansible/available_hosts

counter=1

while read -r ip_address; do
    # Check if the line starts with "10.50."
    if [[ $ip_address == 10.50.* ]]; then
        echo "webserver-$counter ansible_host=$ip_address" >> ~/ansible/available_hosts
    ((counter++))
    fi

done < "$known_hosts"

echo "Load balancer available webservers on $(date) have been added to available_hosts file"
