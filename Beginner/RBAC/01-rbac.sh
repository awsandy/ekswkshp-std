echo "Deploy nginx into rbac-test namespace"
kubectl create namespace rbac-test
kubectl create deploy nginx --image=nginx -n rbac-test
kubectl get all -n rbac-test    
echo "Create user rbac-user "
aws iam create-user --user-name rbac-user
aws iam create-access-key --user-name rbac-user | tee /tmp/create_output.json
echo "script to switch user rbacuser_creds.sh"
cat << EoF > rbacuser_creds.sh
export AWS_SECRET_ACCESS_KEY=$(jq -r .AccessKey.SecretAccessKey /tmp/create_output.json)
export AWS_ACCESS_KEY_ID=$(jq -r .AccessKey.AccessKeyId /tmp/create_output.json)
EoF
echo "Map IAM user to aws-auth"
ACCOUNT_ID=`aws sts get-caller-identity | jq .Account | tr -d '"'`
echo "Check account id is set = ${ACCOUNT_ID}"
kubectl get configmap -n kube-system aws-auth -o yaml > aws-auth.yaml
cat << EoF > auth-temp.yaml
data:
  mapUsers: |
    - userarn: arn:aws:iam::${ACCOUNT_ID}:user/rbac-user
      username: rbac-user
EoF
echo "Apply config map"
cat aws-auth.yaml > aws-auth-new.yaml
cat auth-temp.yaml >> aws-auth-new.yaml
kubectl apply -f aws-auth-new.yaml
echo "Test the new user:"
. ./rbacuser_creds.sh
aws sts get-caller-identity
echo "check we are NOT allowed to get pods from rbac-test"
kubectl get pods -n rbac-test
echo "unset ourselves as rbac-user"
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID
aws sts get-caller-identity
echo "Create RBAC yaml - pod reader"
kubectl apply -f rbacuser-role.yaml
echo "Now create role binding"
kubectl apply -f rbacuser-role-binding.yaml
echo "switch to rbac user"
. rbacuser_creds.sh; aws sts get-caller-identity
echo "check we have access"
kubectl get pods -n rbac-test
echo "check we have no access to kube-system"
kubectl get pods -n kube-system