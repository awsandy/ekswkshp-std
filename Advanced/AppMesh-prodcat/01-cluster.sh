echo "add node group"
envsubst < clusterconfig.yaml | eksctl create nodegroup -f -
kubectl get nodes --sort-by=.metadata.creationTimestamp
