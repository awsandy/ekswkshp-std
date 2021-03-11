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


kubectl delete deployments nginx
kubectl delete service  nginx
kubectl set env ds aws-node -n kube-system AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=false
kubectl describe daemonset aws-node -n kube-system | grep -A5 Environment

echo "deleting custom netwoking resource yaml's"
sub1=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[0].SubnetId' | tr -d '"'`
sub2=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[1].SubnetId'| tr -d '"'`
sub3=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[2].SubnetId' | tr -d '"'`
zone1=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[0].AvailabilityZone'| tr -d '"'`
zone2=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[1].AvailabilityZone'| tr -d '"'`
zone3=`aws ec2 describe-subnets  --filters "Name=cidr-block,Values=100.64.*19" --query 'Subnets[2].AvailabilityZone'| tr -d '"'`
echo "subnet $sub1 zone $zone1"
echo "subnet $sub2 zone $zone2"
echo "subnet $sub3 zone $zone3"
##

kubectl delete eniconfig/${zone1}-pod-netconfig
kubectl delete eniconfig/${zone2}-pod-netconfig
kubectl delete eniconfig/${zone3}-pod-netconfig
