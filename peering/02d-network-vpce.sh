CLOUD9_NAME="cloud9-eksworkshop"
CLUSTER="eksworkshop-eksctl"

resp=`aws eks describe-cluster --name $CLUSTER`
vpcid=`echo $resp | jq .cluster.resourcesVpcConfig.vpcId | tr -d '"'`
sgid=`echo $resp | jq .cluster.resourcesVpcConfig.securityGroupIds[0] | tr -d '"'`

echo "vpce's"
echo "ec2messages"
aws ec2 create-vpc-endpoint --vpc-endpoint-type Interface --vpc-id $vpcid --service-name com.amazonaws.eu-west-1.ec2messages --security-group-ids $sgid
echo "ssmmessages"
aws ec2 create-vpc-endpoint --vpc-endpoint-type Interface --vpc-id $vpcid --service-name com.amazonaws.eu-west-1.ssmmessages --security-group-ids $sgid
echo "ssm"
aws ec2 create-vpc-endpoint --vpc-endpoint-type Interface --vpc-id $vpcid --service-name com.amazonaws.eu-west-1.ssm --security-group-ids $sgid
