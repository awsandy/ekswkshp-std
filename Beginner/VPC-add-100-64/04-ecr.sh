docker pull nginx
reg=`aws configure get region`
acc=`aws sts get-caller-identity | jq .Account | tr -d '"'`
aws ecr get-login-password --region $reg | docker login --username AWS --password-stdin $acc.dkr.ecr.$reg.amazonaws.com
docker tag nginx:latest $acc.dkr.ecr.$reg.amazonaws.com/nginx
docker push $acc.dkr.ecr.$reg.amazonaws.com/nginx