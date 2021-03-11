echo "get OpenID Connect (OIDC) issuer URL"
export CLUSTER="ateks1"
echo "Check OIDC for cluster ${CLUSTER}"
aws eks describe-cluster --name ${CLUSTER} --query cluster.identity.oidc.issuer --output text
#
#
echo "Create your OIDC identity provider for your cluster - see IAM -> Providers"
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER} --approve
#
echo "Get ARN for S3 Read"
#arn=`aws iam list-policies --query 'Policies[?PolicyName==`AmazonS3ReadOnlyAccess`].Arn'`
#
arn="arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
echo $arn
#
echo "Create an IAM role for your service accounts:"
eksctl create iamserviceaccount --name iam-test --namespace default --cluster ${CLUSTER} --attach-policy-arn $arn --approve --override-existing-serviceaccounts
#
echo "check service account exists"
kubectl get sa
echo "check service account annotated with arn"
kubectl describe sa iam-test
echo "deploy sample pod"
#curl -LO https://eksworkshop.com/beginner/110_irsa/deploy.files/iam-pod.yaml
kubectl apply -f iam-pod.yaml
echo "check it's running & get into the pod"
kubectl get pod
kubectl exec -it <place Pod Name> /bin/bash
echo "inside pod do"
#echo "aws sts assume-role-with-web-identity \
#--role-arn $AWS_ROLE_ARN \
#--role-session-name mh9test \
#--web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE \
#--duration-seconds 1000"
echo "this sould work"
echo "aws s3 ls"
echo "this should not work"
echo "aws ec2 describe-instances --region us-west-2"





