aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
PROJECT_NAME=eks-app-mesh-demo
cd eks-app-mesh-polyglot-demo
export APP_VERSION=1.0
for app in catalog_detail product_catalog frontend_node; do
  aws ecr describe-repositories --repository-name $PROJECT_NAME/$app >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name $PROJECT_NAME/$app >/dev/null
  TARGET=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME/$app:$APP_VERSION
  docker build -t $TARGET apps/$app
  docker push $TARGET
done
echo "deploy to EKS"
envsubst < ../deployment/base_app.yaml | kubectl apply -f -
kubectl get deployment,pods,svc -n prodcatalog-ns -o wide
echo "confirm fagate is using SA role"
export BE_POD_NAME=$(kubectl get pods -n prodcatalog-ns -l app=prodcatalog -o jsonpath='{.items[].metadata.name}') 
kubectl describe pod ${BE_POD_NAME} -n  prodcatalog-ns | grep 'AWS_ROLE_ARN\|AWS_WEB_IDENTITY_TOKEN_FILE\|serviceaccount' 
echo "Confirm fargate logging is enabled"
kubectl describe pod ${BE_POD_NAME} -n  prodcatalog-ns | grep LoggingEnabled