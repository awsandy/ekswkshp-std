kubectl apply -f https://eksworkshop.com/intermediate/245_x-ray/sample-front.files/x-ray-sample-front-k8s.yml

kubectl apply -f https://eksworkshop.com/intermediate/245_x-ray/sample-back.files/x-ray-sample-back-k8s.yml
kubectl describe deployments x-ray-sample-front-k8s x-ray-sample-back-k8s
kubectl describe services x-ray-sample-front-k8s x-ray-sample-back-k8s
kubectl get service x-ray-sample-front-k8s -o wide


