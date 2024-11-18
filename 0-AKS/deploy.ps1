# create the service account (used for workload identity)
# NOTE: be sure to update the azure.workload.identity/client-id annotation
kubectl apply -f .\serviceaccount.yaml

# deploy the app and service
kubectl apply -f .\deployment.yaml -f .\service.yaml

# get the IP of the service load balancer
$ip = kubectl get svc secretapi --output jsonpath="{.status.loadBalancer.ingress[0].ip}"

"Public service IP address: http://$($ip)"