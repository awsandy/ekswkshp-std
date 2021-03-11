kubectl apply -f job-node.yaml 
sleep 2
kubectl get pods --all-namespaces | grep kube-bench