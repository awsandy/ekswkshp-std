envsubst < eks-app-mesh-polyglot-demo/deployment/fluentbit-config.yaml | kubectl apply -f -
echo "should see aws-loggining" 
kubectl -n aws-observability get cm
echo "get permissions to write to CW"
curl -o permissions.json \
     https://raw.githubusercontent.com/aws-samples/amazon-eks-fluent-logging-examples/mainline/examples/fargate/cloudwatchlogs/permissions.json
aws iam create-policy \
        --policy-name FluentBitEKSFargate \
        --policy-document file://permissions.json 
echo "attach policy to pod execution role"
export PodRole=$(aws eks describe-fargate-profile --cluster-name ${CLUSTER} --fargate-profile-name fargate-productcatalog --query 'fargateProfile.podExecutionRoleArn' | sed -n 's/^.*role\/\(.*\)".*$/\1/ p')
aws iam attach-role-policy \
        --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/FluentBitEKSFargate \
        --role-name ${PodRole}
echo $PodRole
echo "fargate pod execution role should now have this extra policy attached"

