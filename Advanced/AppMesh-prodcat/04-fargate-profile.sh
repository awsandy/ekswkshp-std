envsubst < ./deployment/clusterconfig.yaml | eksctl create fargateprofile -f -
eksctl get fargateprofile --cluster eksworkshop-eksctl -o yaml
