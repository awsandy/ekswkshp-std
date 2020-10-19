eksctl utils associate-iam-oidc-provider --cluster eksworkshop-eksctl --approve
eksctl create iamserviceaccount --name xray-daemon --namespace default --cluster eksworkshop-eksctl --attach-policy-arn arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess --approve --override-existing-serviceaccounts
kubectl label serviceaccount xray-daemon app=xray-daemon
