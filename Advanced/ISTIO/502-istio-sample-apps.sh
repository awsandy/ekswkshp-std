# sample app is in environment/istio-1.4.2
#
cd environment/istio-1.4.2
kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)
# Alternatively to the above, you can deploy any resource separately:
#
#   kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml -l service=reviews # reviews Service
#   kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml -l account=reviews # reviews ServiceAccount
#   kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml -l app=reviews,version=v3 # reviews-v3 Deployment
#
kubectl get pod,svc
echo "define virtual serv and ingress gateway"
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
echo "query ingress gateway"
kubectl get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' -n istio-system ; echo
echo "put DNS into browser and same with /productpage"
