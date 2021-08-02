#!/bin/bash
oc whoami --show-token > $HOME/.usertoken.txt
oc login --token=$(cat $HOME/.token.txt) --server=$(cat $HOME/.server.txt) --insecure-skip-tls-verify="false" > /dev/null 2>&1 || { echo "login not ok. Exit code: $?"; exit 1; }
echo "Deleting server..."
oc delete all --all -n os-code > /dev/null 2>&1
oc delete pvc/code-server-projects -n os-code > /dev/null 2>&1
oc project default > /dev/null 2>&1
oc delete project/os-code > /dev/null 2>&1
oc login --token=$(cat $HOME/.usertoken.txt) --server=$(cat $HOME/.server.txt) > /dev/null 2>&1
rm -rf $HOME/.usertoken.txt $HOME/.server.txt $HOME/.token.txt > /dev/null 2>&1
sleep 10 
echo "Code server deleted"