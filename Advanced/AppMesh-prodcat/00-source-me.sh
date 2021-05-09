export CLUSTER=mycluster1
export AWS_REGION=eu-west-1
export APP_VERSION=1.0
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account | jq -r)
/Users/awsandy/odp/aws/sw/Terraform-EKS-Internal/Launch/nodeg/reannotate-nodes.sh mycluster1