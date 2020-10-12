if  [ -n "$AWS_REGION" ] ;then
echo "AWS_REGION is $AWS_REGION" 
else
echo "AWS_REGION is not set this must be done before proceeding"
exit
fi
if  [ -n "$CLUSTER" ] ;then
echo "CLUSTER is $CLUSTER" 
else
echo "CLUSTER is not set this must be done before proceeding"
exit
fi
STACK_NAME=$(eksctl get nodegroup --cluster ${CLUSTER} -o json | jq -r '.[].StackName')
ROLE_NAME=$(aws cloudformation describe-stack-resources --stack-name $STACK_NAME | jq -r '.StackResources[] | select(.ResourceType=="AWS::IAM::Role") | .PhysicalResourceId')
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
aws iam list-attached-role-policies --role-name $ROLE_NAME | grep CloudWatchAgentServerPolicy || echo 'Policy not found'
curl -s https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/${CLUSTER}/;s/{{region_name}}/${AWS_REGION}/" | kubectl apply -f -
kubectl -n amazon-cloudwatch get daemonsets
#namespace/amazon-cloudwatch created
#serviceaccount/cloudwatch-agent created
#clusterrole.rbac.authorization.k8s.io/cloudwatch-agent-role created
#clusterrolebinding.rbac.authorization.k8s.io/cloudwatch-agent-role-binding created
#configmap/cwagentconfig created
#daemonset.apps/cloudwatch-agent created
#configmap/cluster-info created
#serviceaccount/fluentd created
#clusterrole.rbac.authorization.k8s.io/fluentd-role created
#clusterrolebinding.rbac.authorization.k8s.io/fluentd-role-binding created
#configmap/fluentd-config created
#daemonset.apps/fluentd-cloudwatch created
