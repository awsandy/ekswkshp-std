if  [ -n "$EXTERNAL_IP" ] ;then
echo "EXTERNAL_IP is $EXTERNAL_IP" 
else
echo "EXTERNAL_IP is not set this must be done before proceeding"
kubectl get service -n nginx-ingress-sample
exit
fi

SAMPLE_TRAFFIC_NAMESPACE=nginx-sample-traffic
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/service/cwagent-prometheus/sample_traffic/nginx-traffic/nginx-traffic-sample.yaml | 
sed "s/{{external_ip}}/$EXTERNAL_IP/g" | 
sed "s/{{namespace}}/$SAMPLE_TRAFFIC_NAMESPACE/g" | 
kubectl apply -f -
