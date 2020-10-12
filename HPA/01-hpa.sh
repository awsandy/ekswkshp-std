# create the metrics-service namespace first
kubectl create namespace metrics
helm repo update
helm install metrics-server \
    stable/metrics-server \
    --version 2.11.1 \
    --namespace metrics

#kubectl describe hpa
echo "check"
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"
kubectl get apiservice v1beta1.metrics.k8s.io -o json
kubectl get apiservice v1beta1.metrics.k8s.io -o json | jq .status.conditions[].message
echo "deploy sample app"
kubectl create -f php-apache.yaml
echo "create an hpa resource"
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=20
kubectl get hpa
sleep 60
kubectl get hpa
echo "kubectl run -i --tty load-generator --image=busybox /bin/sh"
echo "while true; do wget -q -O - http://php-apache; done"
kubectl get hpa -w


