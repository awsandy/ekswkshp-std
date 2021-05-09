kubectl delete namespace prodcatalog-ns
aws ecr delete-repository --repository-name eks-app-mesh-demo/catalog_detail --force
aws ecr delete-repository --repository-name eks-app-mesh-demo/frontend_node --force
aws ecr delete-repository --repository-name eks-app-mesh-demo/product_catalog --force
echo "disable cluster logging"
eksctl utils update-cluster-logging --disable-types all \
    --region ${AWS_REGION} \
    --cluster eksworkshop-eksctl \
    --approve
echo "delete cloudwatch namespace"
kubectl delete namespace amazon-cloudwatch
echo "delete observability namespace"
kubectl delete namespace aws-observability
echo "delete product catalog mesh"
kubectl delete meshes prodcatalog-mesh
echo "uninstall helm app mesh controller "
helm -n appmesh-system delete appmesh-controller
echo "delete App Mesh CRD's"
for i in $(kubectl get crd | grep appmesh | cut -d" " -f1) ; do
kubectl delete crd $i
done
echo "delete ISRM"
eksctl delete iamserviceaccount  --cluster eksworkshop-eksctl --namespace appmesh-system --name appmesh-controller
echo "delete app mesh namespace"
kubectl delete namespace appmesh-system
echo "delete fargate logging policy"
export PodRole=$(aws eks describe-fargate-profile --cluster-name eksworkshop-eksctl --fargate-profile-name fargate-productcatalog --query 'fargateProfile.podExecutionRoleArn' | sed -n 's/^.*role\/\(.*\)".*$/\1/ p')
aws iam detach-role-policy \
        --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/FluentBitEKSFargate \
        --role-name ${PodRole}
aws iam delete-policy --policy-arn arn:aws:iam::$ACCOUNT_ID:policy/FluentBitEKSFargate
echo "delete fargate service account"
eksctl delete iamserviceaccount --cluster eksworkshop-eksctl   --namespace prodcatalog-ns --name prodcatalog-sa
echo "delete fargate profile"
eksctl delete fargateprofile \
  --name fargate-productcatalog \
  --cluster eksworkshop-eksctl
echo "delete nodegroup"
envsubst < ./deployment/clusterconfig.yaml | eksctl delete nodegroup -f -  --approve
