kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/prometheus-eks.yaml
kubectl get pod -l "app=cwagent-prometheus" -n amazon-cloudwatch
echo "enable control plane logs"
eksctl utils update-cluster-logging \
	--enable-types all \
    --region ${AWS_REGION} \
    --cluster eksworkshop-eksctl \
    --approve
echo "enable fargate loggining"
