oc whoami --show-token > .usertoken.txt
oc new-project os-code > /dev/null 2>&1
echo "Creating environment..."
oc create sa os-code > /dev/null 2>&1
oc adm policy add-cluster-role-to-user cluster-admin -z os-code > /dev/null 2>&1
oc whoami --show-server > server.txt
oc sa get-token os-code > token.txt
adm policy add-scc-to-user privileged -z os-code > /dev/null 2>&1
oc login --token=$(cat token.txt) --server=$(cat server.txt) --insecure-skip-tls-verify="false" > /dev/null 2>&1 || { echo "login not ok. Exit code: $?"; exit 1; }
openssl rand -base64 16 > .password.txt
oc new-app -f https://raw.githubusercontent.com/jefferyb/code-server-openshift/master/code-server-openshift-template.yaml -p URL=placeholder.com -p CODER_PASSWORD=$(cat .password.txt) | grep created
oc delete route/code-server > /dev/null 2>&1
oc create route edge --service=code-server > /dev/null 2>&1
echo "Code server initialized..."
oc logout > /dev/null 2>&1
oc login --token=$(cat .usertoken.txt) --server=$(cat server.txt) > /dev/null 2>&1
rm -rf .usertoken.txt > /dev/null 2>&1
echo "Server will usually take a few minutes to deploy"
echo "Your code server will be hosted at: $(oc get routes -n os-code code-server -o=jsonpath='{ .spec.host }')"
echo "The password to sign in is: $(cat .password.txt)"
rm -rf .password.txt