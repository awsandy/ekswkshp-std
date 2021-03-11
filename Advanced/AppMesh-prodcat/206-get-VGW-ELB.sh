export LB_NAME=$(kubectl get svc ingress-gw -n prodcatalog-ns -o jsonpath="{.status.loadBalancer.ingress[*].hostname}") 
 curl -v --silent ${LB_NAME} | grep x-envoy
echo $LB_NAME
curl -v $LB_NAME