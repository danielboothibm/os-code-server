#!/bin/bash
oc whoami --show-token > $HOME/.usertoken.txt
oc new-project os-code > /dev/null 2>&1
echo "Creating environment..."
oc create sa os-code > /dev/null 2>&1
oc adm policy add-cluster-role-to-user cluster-admin -z os-code > /dev/null 2>&1
oc whoami --show-server > $HOME/.server.txt
oc sa get-token os-code > $HOME/.token.txt
adm policy add-scc-to-user privileged -z os-code > /dev/null 2>&1
oc login --token=$(cat $HOME/.token.txt) --server=$(cat $HOME/.server.txt) --insecure-skip-tls-verify="false" > /dev/null 2>&1 || { echo "login not ok. Exit code: $?"; exit 1; }
oc new-app --name=code-server --strategy docker https://github.com/danielboothibm/os-code-server.git --as-deployment-config -l app=code-server | grep created
oc create route edge --service=code-server > /dev/null 2>&1
echo "Code server initialized..."
oc logout > /dev/null 2>&1
oc login --token=$(cat $HOME/.usertoken.txt) --server=$(cat $HOME/.server.txt) > /dev/null 2>&1
rm -rf $HOME/.usertoken.txt > /dev/null 2>&1
echo "Server will usually take a few minutes to deploy"
echo "Your code server will be hosted at: https://$(oc get routes -n os-code code-server -o=jsonpath='{ .spec.host }')"
echo "You can see the status of your environment and access credentials by running:"
echo "os-code status"