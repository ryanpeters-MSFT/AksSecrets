# deploy the app and service
kubectl apply -f .\deployment.yaml -f .\service.yaml

# get the IP of the service load balancer
$ip = kubectl get svc secretapi --output jsonpath="{.status.loadBalancer.ingress[0].ip}"

"Navigate to: http://$($ip)"