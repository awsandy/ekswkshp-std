echo "test 1 - from frontend to Fargate based product catalog"
export FE_POD_NAME=$(kubectl get pods -n prodcatalog-ns -l app=frontend-node -o jsonpath='{.items[].metadata.name}') 
echo "from the # "
echo "curl  http://prodcatalog.prodcatalog-ns.svc.cluster.local:5000/products/"
echo "then exit"
kubectl -n prodcatalog-ns exec -it ${FE_POD_NAME} -c frontend-node bash
echo "test2 from fargate product catalog to nodegroup based prod detail"
export BE_POD_NAME=$(kubectl get pods -n prodcatalog-ns -l app=prodcatalog -o jsonpath='{.items[].metadata.name}') 
kubectl -n prodcatalog-ns exec -it ${BE_POD_NAME} -c prodcatalog bash
echo "from the # "
echo "curl http://proddetail.prodcatalog-ns.svc.cluster.local:3000/catalogDetail"
echo "then exit"

