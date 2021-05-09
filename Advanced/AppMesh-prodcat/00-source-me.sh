export CLUSTER=mycluster1
export AWS_REGION=eu-west-1
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account | jq -r)