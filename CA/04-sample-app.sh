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

kubectl get deployment/nginx-to-scaleout
echo "the requests/limits should force the CA"
echo "scale to 10 replicas"
kubectl scale --replicas=10 deployment/nginx-to-scaleout
echo "sleep for 10"
sleep 10
kubectl get pods -l app=nginx -o wide
kubectl -n kube-system logs -f deployment/cluster-autoscaler
echo "kubectl get pods -l app=nginx -o wide"
echo "kubectl -n kube-system logs -f deployment/cluster-autoscaler"
echo "kubectl get nodes"