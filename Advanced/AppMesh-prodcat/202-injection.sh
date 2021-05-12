kubectl get pods -n prodcatalog-ns -o wide
echo "simply restart the deployments - App Mesh controller will handle the rest !!"
echo " faregate pod can take up to 6 minutes"
kubectl -n prodcatalog-ns rollout restart deployment prodcatalog
kubectl -n prodcatalog-ns rollout restart deployment proddetail 
kubectl -n prodcatalog-ns rollout restart deployment frontend-node
kubectl get pods -n prodcatalog-ns -o wide
POD=$(kubectl -n prodcatalog-ns get pods -o jsonpath='{.items[0].metadata.name}')
sleep 4
echo " should see 2x sidecars - envoy & xray"
kubectl -n prodcatalog-ns get pods ${POD} -o jsonpath='{.spec.containers[*].name}'; echo
kubectl get pods -n prodcatalog-ns