#aws autoscaling \
#    describe-auto-scaling-groups \
#    --query "AutoScalingGroups[? Tags[? (Key=='eks:cluster-name') && Value=='eksworkshop-eksctl']].[AutoScalingGroupName, MinSize, MaxSize,DesiredCapacity]" \
#    --output table
# we need the ASG name
#export ASG_NAME=$(aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[? Tags[? (Key=='eks:cluster-name') && Value=='eksworkshop-eksctl']].AutoScalingGroupName" --output text)

# increase max capacity up to 4
#aws autoscaling \
#    update-auto-scaling-group \
#    --auto-scaling-group-name ${ASG_NAME} \
#    --min-size 2 \
#    --desired-capacity 2 \
#    --max-size 4

# Check new values
# aws autoscaling \
#    describe-auto-scaling-groups \
#    --query "AutoScalingGroups[? Tags[? (Key=='eks:cluster-name') && Value=='eksworkshop-eksctl']].[AutoScalingGroupName, MinSize, MaxSize,DesiredCapacity]" \
#    --output table

aws eks update-nodegroup-config --cluster-name eksworkshop-eksctl --nodegroup-name nodegroup --scaling-config minSize=2,maxSize=4,desiredSize=2