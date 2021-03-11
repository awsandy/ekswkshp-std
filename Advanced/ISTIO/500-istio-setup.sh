cd environment
curl -L https://git.io/getLatestIstio | sh -
cd istio-1.4.2
sudo mv -v bin/istioctl /usr/local/bin/
istioctl version
