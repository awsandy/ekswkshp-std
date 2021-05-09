echo "create namespace and mesh"
kubectl apply -f deployment/mesh.yaml 
kubectl describe namespace prodcatalog-ns
kubectl describe mesh prodcatalog-mesh
echo "create app mesh resources for services"
echo "v-services, v-routers, v-nodes"
kubectl apply -f deployment/meshed_app.yaml
kubectl get virtualnode,virtualservice,virtualrouter -n prodcatalog-ns
echo "examine in console"
echo "- 3x services frontend, prodcatalog, prodetail"
echo "- 2x routers prodcatalog, prodetail"
echo "- 3x nodes frontend prodcatalog, prodetail"