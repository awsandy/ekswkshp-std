cd environment/istio-1.4.2
#To remove telemetry configuration / port-forward process
kubectl delete -f istio-telemetry.yaml
#To remove the application virtual services /
kubectl delete -f samples/bookinfo/networking/virtual-service-all-v1.yaml
# & destination rules
kubectl delete -f samples/bookinfo/networking/destination-rule-all.yaml
#To remove the gateway 
kubectl delete -f samples/bookinfo/networking/bookinfo-gateway.yaml
#To remove the application
kubectl delete -f samples/bookinfo/platform/kube/bookinfo.yaml
# remove istio
helm delete --purge istio
helm delete --purge istio-init
