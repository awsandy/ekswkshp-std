eksctl utils associate-iam-oidc-provider \
    --region ${AWS_REGION} \
    --cluster ${CLUSTER} \
    --approve
envsubst < clusterconfig.yaml | eksctl create iamserviceaccount -f - --approve
kubectl describe sa prodcatalog-sa -n prodcatalog-ns

