nc=`aws eks list-clusters | jq '.clusters | length'`
if [ $nc == 1 ] ; then
export CLUSTER=`aws eks list-clusters | jq '.clusters[0]' | tr -d '"'`
echo "EKS Cluster = $CLUSTER"
else
    if  [ -z "$CLUSTER" ] ;then
        echo "Please set the environment variable CLUSTER"
        exit
    fi
fi
VPC_ID=$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=*$CLUSTER* | jq -r '.Vpcs[].VpcId')
if  [ -n "$VPC_ID" ] ;then
echo $VPC_ID
else
echo "Could not find VPC is not set this must be done before proceeding"
exit
fi
ASSOCIATION_ID=$(aws ec2 describe-vpcs --vpc-id $VPC_ID | jq -r '.Vpcs[].CidrBlockAssociationSet[] | select(.CidrBlock == "100.64.0.0/16") | .AssociationId')

CGNAT_SNET1=$(aws ec2 describe-subnets --filters Name=cidr-block,Values=100.64.0.0/19 Name=vpc-id,Values=$VPC_ID | jq -r '.Subnets[].SubnetId')
CGNAT_SNET2=$(aws ec2 describe-subnets --filters Name=cidr-block,Values=100.64.32.0/19 Name=vpc-id,Values=$VPC_ID | jq -r '.Subnets[].SubnetId')
CGNAT_SNET3=$(aws ec2 describe-subnets --filters Name=cidr-block,Values=100.64.64.0/19 Name=vpc-id,Values=$VPC_ID | jq -r '.Subnets[].SubnetId')
echo "delete subnets $CGNAT_SNET1"
aws ec2 delete-subnet --subnet-id $CGNAT_SNET1
echo "delete subnets $CGNAT_SNET2"
aws ec2 delete-subnet --subnet-id $CGNAT_SNET2
echo "delete subnets $CGNAT_SNET3"
aws ec2 delete-subnet --subnet-id $CGNAT_SNET3
echo "undo 100.64 cidr association  $ASSOCIATION_ID"
aws ec2 disassociate-vpc-cidr-block --association-id $ASSOCIATION_ID

