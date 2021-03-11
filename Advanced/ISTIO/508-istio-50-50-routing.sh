cd environment/istio-1.4.2
# define 50:50 routing with istio
kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml
#spec:
#  hosts:
#  - reviews
#  http:
#  - route:
#    - destination:
#        host: reviews
#        subset: v1
#      weight: 50
#    - destination:
#        host: reviews
#        subset: v3
#      weight: 50
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
kubectl get virtualservice reviews -o yaml



