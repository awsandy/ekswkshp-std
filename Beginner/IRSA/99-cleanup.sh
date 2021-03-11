kubectl delete -f iam-pod.yaml
eksctl delete iamserviceaccount --name iam-test --namespace default --cluster ${CLUSTER}
