cd environment/istio-1.4.2
kubectl apply -f install/kubernetes/helm/helm-service-account.yaml
helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system
echo "check installation"
kubectl get crds --namespace istio-system | grep 'istio.io'
echo "install istio"
helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set global.configValidation=false --set sidecarInjectorWebhook.enabled=false --set grafana.enabled=true --set servicegraph.enabled=true
echo "sleep 60"
sleep 60
echo "verify services"
kubectl get svc -n istio-system
echo "check pods"
kubectl get pods -n istio-system
