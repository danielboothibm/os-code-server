oc whoami --show-token > .usertoken.txt
oc login --token=$(cat token.txt) --server=$(cat server.txt) --insecure-skip-tls-verify="false" > /dev/null 2>&1 || { echo "login not ok. Exit code: $?"; exit 1; }
echo "Deleting server..."
oc delete all --all -n os-code > /dev/null 2>&1
oc delete pvc/code-server-projects -n os-code > /dev/null 2>&1
oc project default > /dev/null 2>&1
oc delete project/os-code > /dev/null 2>&1
oc login --token=$(cat .usertoken.txt) --server=$(cat server.txt) > /dev/null 2>&1
rm -rf .usertoken.txt > /dev/null 2>&1
sleep 10 
echo "Code server deleted"