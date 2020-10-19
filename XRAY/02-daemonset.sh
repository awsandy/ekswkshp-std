kubectl create -f https://eksworkshop.com/intermediate/245_x-ray/daemonset.files/xray-k8s-daemonset.yaml
kubectl describe daemonset xray-daemon
kubectl logs -l app=xray-daemon