aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
cd eks-app-mesh-polyglot-demo
PROJECT_NAME=eks-app-mesh-demo
export APP_VERSION_2=2.0
for app in catalog_detail; do
  aws ecr describe-repositories --repository-name $PROJECT_NAME/$app >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name $PROJECT_NAME/$app >/dev/null
  TARGET=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$PROJECT_NAME/$app:$APP_VERSION_2
  cd apps/$app
  docker build -t $TARGET -f version2/Dockerfile .
  docker push $TARGET
done
cd ../../.
echo "chnage prod detail router 90% v1 10% v2"
envsubst < ./deployment/canary.yaml | kubectl apply -f -
echo "check"
kubectl get all -n prodcatalog-ns | grep 'proddetail2\|proddetail-v2'
export LB_NAME=$(kubectl get svc ingress-gw -n prodcatalog-ns -o jsonpath="{.status.loadBalancer.ingress[*].hostname}") 
echo $LB_NAME
echo "curl it a few times"