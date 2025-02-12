# echo importing kubectl aliases
alias k='kubectl'
alias kci='kubectl cluster-info'
alias kcid='kubectl cluster-info dump'
alias kexec='kubectl exec'
alias kg='kubectl get'
alias kgpo='kubectl get pod'
alias kd='kubectl describe'
alias kdpo='kubectl describe pod'
alias kdel='kubectl delete'
alias kgd='kubectl get deployments'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployments'
alias kdeld='kubectl delete deployments'
alias kgn='kubectl get node'
alias kdn='kubectl describe node'
alias kdeln='kubectl delete node'
alias kgns='kubectl get namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
alias kgs='kubectl get services'
alias kds='kubectl describe services'
alias kdels='kubectl delete services'
alias kgx='kubectl get secret'
alias kdx='kubectl describe secret'
alias kdelx='kubectl delete secret'
alias kgcm='kubectl get configmaps'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'
alias kgctx='kubectl config current-context'
alias kctx='kgctx'
alias kusectx='kubectl config use-context'
alias ksetctx='kusectx'
alias ksctx='ksetctx'

# ddiaas aliases
# endpoint manager
alias qem='k -n ddiaas-endpoint-manager'
alias qemgepc='qem get epc'
alias qepc='qemgepc'
alias qeml='qem logs'
alias qemx='qem exec -it'
# dataplane
alias qd='k -n ddiaas-dataplane'
alias qdgds='qd get ds'
alias qdx='qd exec -it'
alias qdl='qd logs'
# apps
alias qdns='k -n ddiaas-dns-endpoint'
alias qdnsx='qdns exec -it'
alias qdnsl='qdns logs'
alias qdhcp='k -n ddiaas-dhcp-endpoint'
alias qdhcpx='qdhcp exec -it'
alias qdhcpl='qdhcp logs'

# for the saas-app-deployment https://github.com/Infoblox-CTO/saas-app-deployment/tree/master/deployment/ngp-onprem#33--setup-environment-variables
# export USER=$(git config user.email | sed -e 's/\@.*//')
export REGISTRY_TAG=infobloxcto
export VERSION_TAG=3.2.0 # Please use the latest version in https://hub.docker.com/r/infobloxcto/onprem.agent/
export CSP_HOST=www-test.csp.infoblox.com # Change this with CSP that is being used by your team
export S3_BUCKET=https://s3.amazonaws.com/ib-noa-test/gshirazi # Change this with the bucket/folder created for you
export AWS_IAM_ROLE=ngp.k8.core
export KUBERNETES_NAMESPACE=g # Namespace that you created in Section 2.1

# helm
# export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
# export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
# export AWS_REGION=$(aws configure get region)
# export AWS_SESSION_TOKEN=$(aws configure get aws_session_token)

alias helm='docker run --rm -v $PWD:/app -e AWS_REGION=${AWS_REGION} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} infoblox/helm:3'
alias hl='helm list'
alias hls='helm list'
alias hli='helm lint'
alias hd='helm delete'
alias hi='helm install'

