envsubst < eks-app-mesh-polyglot-demo/deployment/clusterconfig.yaml | eksctl create fargateprofile -f -
eksctl get fargateprofile --cluster $CLUSTER -o yaml
