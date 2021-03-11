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
INSTANCE_IDS=(`aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag-key,Values=eks:cluster-name" "Name=tag-value,Values=$CLUSTER*" --output text` )
for i in "${INSTANCE_IDS[@]}"
do
echo "Terminating EC2 instance $i ..."
aws ec2 terminate-instances --instance-ids $i
done


