kubectl delete deployment.apps/prodcatalog -n prodcatalog-ns
kubectl delete deployment.apps/proddetail -n prodcatalog-ns
kubectl delete deployment.apps/frontend-node -n prodcatalog-ns
kubectl delete service/frontend-node -n prodcatalog-ns
kubectl delete service/prodcatalog -n prodcatalog-ns
kubectl delete service/proddetail -n prodcatalog-ns