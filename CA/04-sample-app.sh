cat <<EoF> nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-to-scaleout
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        service: nginx
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx-to-scaleout
        resources:
          limits:
            cpu: 500m
            memory: 512Mi
          requests:
            cpu: 500m
            memory: 512Mi
EoF

kubectl apply -f nginx.yaml

#kubectl -n kube-system logs -f deployment/cluster-autoscaler
echo "circa 2m to scale out and extra pods running"
echo "takes circa 15, to scale down - cooldown = 7.5m, ASG event 10m - complete 12m"
echo "kubectl get pods -l app=nginx -o wide"
echo "kubectl -n kube-system logs -f deployment/cluster-autoscaler"
echo "kubectl get nodes"