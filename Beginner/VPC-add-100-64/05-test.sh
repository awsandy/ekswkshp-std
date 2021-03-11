reg=`aws configure get region`
acc=`aws sts get-caller-identity | jq .Account | tr -d '"'`
kubectl create deployment nginx --image=$acc.dkr.ecr.$reg.amazonaws.com/nginx
kubectl scale --replicas=3 deployments/nginx
kubectl expose deployment/nginx --type=NodePort --port 80
echo "sleep 10"
sleep 10
kubectl get pods -o wide
echo "kubectl run -i --rm --tty debug --image=busybox -- sh"
echo "wget google.com -O -"
echo "wget nginx -O -"