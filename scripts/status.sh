echo "Your code server is running on pod:"

oc -n os-code get pod -l "app=code-server"

echo ""

echo "It is accepting traffic at:"

oc get routes code-server -o=jsonpath='{ .spec.host }'

echo ""
echo ""

echo "The password to sign in is:"

oc exec $(oc -n os-code get pod -l "app=code-server" -o jsonpath='{.items[*].metadata.name}') -- printenv | grep CODER_PASSWORD