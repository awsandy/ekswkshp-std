helm repo add eks https://aws.github.io/eks-charts
helm repo update
kubectl create ns appmesh-system

# Create your OIDC identity provider for the cluster
eksctl utils associate-iam-oidc-provider \
  --cluster ${CLUSTER} \
  --approve

# Create an IAM role for the appmesh-controller service account
eksctl create iamserviceaccount \
  --cluster ${CLUSTER} \
  --namespace appmesh-system \
  --name appmesh-controller \
  --attach-policy-arn  arn:aws:iam::aws:policy/AWSCloudMapFullAccess,arn:aws:iam::aws:policy/AWSAppMeshFullAccess \
  --override-existing-serviceaccounts \
  --approve

  helm upgrade -i appmesh-controller eks/appmesh-controller \
    --namespace appmesh-system \
    --set region=$AWS_REGION \
    --set serviceAccount.create=false \
    --set serviceAccount.name=appmesh-controller \
    --set tracing.enabled=true \
    --set tracing.provider=x-ray

echo "check installed version > 1.0"
kubectl get deployment appmesh-controller \
    -n appmesh-system \
    -o json  | jq -r ".spec.template.spec.containers[].image" | cut -f2 -d ':'

echo "app mesh crd's - should be 6x"
kubectl get crds | grep appmesh
echo "check it's running ok "
kubectl -n appmesh-system get all          


