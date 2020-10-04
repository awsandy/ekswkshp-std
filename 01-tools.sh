sudo curl --silent --location -o /usr/local/bin/kubectl \
  https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl

sudo chmod +x /usr/local/bin/kubectl
sudo pip install --upgrade awscli && hash -r
sudo yum -y install jq gettext bash-completion moreutils
echo 'yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}' | tee -a ~/.bashrc && source ~/.bashrc
for command in kubectl jq envsubst aws
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
kubectl completion bash >>  ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
echo 'export ALB_INGRESS_VERSION="v1.1.8"' >>  ~/.bash_profile
.  ~/.bash_profile

