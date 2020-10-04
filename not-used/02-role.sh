echo "IAM role eksworkshop-admin"
aws iam list-instance-profiles-for-role --role-name eksworkshop-admin
aws iam remove-role-from-instance-profile --role-name eksworkshop-admin --instance-profile-name eksworkshop-admin
aws iam delete-instance-profile --instance-profile-name eksworkshop-admin
aws iam detach-role-policy --role-name eksworkshop-admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam delete-role --role-name eksworkshop-admin
aws iam create-role --role-name eksworkshop-admin --assume-role-policy-document file://role-trust-policy.json
aws iam attach-role-policy --role-name eksworkshop-admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-instance-profile --instance-profile-name eksworkshop-admin
sleep 5
aws iam add-role-to-instance-profile --instance-profile-name eksworkshop-admin --role-name eksworkshop-admin
# get instance id
instid=`aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[] | select(.Tags[].Value | contains("cloud9-eksworkshop")).InstanceId' | head -1 | tr -d '"'`
echo $instid
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=eksworkshop-admin --instance-id $instid
