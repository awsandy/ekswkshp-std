# define istio subsets 
cd environment/istio-1.4.2
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
kubectl get destinationrules -o yaml
