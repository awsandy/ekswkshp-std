cd environment/istio-1.4.2
# route to reviews:v1 only
#spec:
#  hosts:
#  - reviews
#  http:
#  - route:
#    - destination:
#        host: reviews
#        subset: v1
kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml
kubectl get virtualservices reviews -o yaml
echo "no reload page multiple time"
# route user jason to v2
#spec:
#  hosts:
#  - reviews
#  http:
#  - match:
#    - headers:
#        end-user:
#          exact: jason
#    route:
#    - destination:
#        host: reviews
#        subset: v2
#  - route:
#    - destination:
#        host: reviews
#        subset: v1
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
kubectl get virtualservices reviews -o yaml
echo "login jason - blank pw"

