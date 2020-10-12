kubectl get deployment/nginx-to-scaleout
echo "the requests/limits should force the CA"
echo "scale to 10 replicas"
kubectl scale --replicas=10 deployment/nginx-to-scaleout
echo "sleep for 10"
sleep 10
kubectl get pods -l app=nginx -o wide