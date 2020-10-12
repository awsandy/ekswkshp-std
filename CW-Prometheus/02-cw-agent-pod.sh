if  [ -n "$AWS_REGION" ] ;then
echo "AWS_REGION is $AWS_REGION" 
else
echo "AWS_REGION is not set this must be done before proceeding"
exit
fi
if  [ -n "$CLUSTER" ] ;then
echo "CLUSTER is $CLUSTER" 
else
echo "CLUSTER is not set this must be done before proceeding"
exit
fi
rm -f prometheus-k8s.yaml
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/prometheus-k8s.yaml | sed "s/{{cluster_name}}/${CLUSTER}/;s/{{region_name}}/${AWS_REGION}/" | kubectl apply -f -
kubectl get pod -l "app=cwagent-prometheus" -n amazon-cloudwatch
