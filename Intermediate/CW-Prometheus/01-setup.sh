kubectl delete deployment cwagent-prometheus -n amazon-cloudwatch
kubectl create namespace amazon-cloudwatch
rm -f prometheus-eks.yaml
wget https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/prometheus-eks.yaml
kubectl apply -f prometheus-eks.yaml
