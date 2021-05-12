echo "VGW - envoy on it's own"
echo "expose the frontend via VGW"
kubectl apply -f eks-app-mesh-polyglot-demo/deployment/virtual_gateway.yaml
kubectl get all  -n prodcatalog-ns -o wide | grep ingress
echo "also check VGW in console"
echo "wait ~5min and get LB"

