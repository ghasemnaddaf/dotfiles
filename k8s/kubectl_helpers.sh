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

function kclogin() {
  tsh --auth=github --proxy=auth-$1.test.infoblox.com:3080 login $1
}

alias k2='kclogin env-2'
alias k4='kclogin env-4'
alias k5='kclogin env-5'

# for the contacts app, FIXME: they do not work when connected to VPN
# KC_SERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
# KC_SECRET_NAME=$(kubectl get secrets | grep ^default | cut -f1 -d ' ')
# KC_TOKEN=$(kubectl describe secret $KC_SECRET_NAME | grep -E '^token' | cut -f2 -d':' | tr -d " ")
# alias kcc='curl --insecure --header "Authorization: Bearer ${KC_TOKEN_CONTACTS_APP}"'
# alias kcci='curl --insecure --header "Authorization: Bearer ${KC_TOKEN}" ${KC_SERVER}/api'

# for the saas-app-deployment https://github.com/Infoblox-CTO/saas-app-deployment/tree/master/deployment/ngp-onprem#33--setup-environment-variables
# export USER=$(git config user.email | sed -e 's/\@.*//')
export REGISTRY_TAG=infobloxcto
export VERSION_TAG=3.2.0 # Please use the latest version in https://hub.docker.com/r/infobloxcto/onprem.agent/
export CSP_HOST=www-test.csp.infoblox.com # Change this with CSP that is being used by your team
export S3_BUCKET=https://s3.amazonaws.com/ib-noa-test/gshirazi # Change this with the bucket/folder created for you
export AWS_IAM_ROLE=ngp.k8.core
export KUBERNETES_NAMESPACE=g # Namespace that you created in Section 2.1

# helm
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export AWS_REGION=$(aws configure get region)
export AWS_SESSION_TOKEN=$(aws configure get aws_session_token)

alias helm='docker run --rm -v $PWD:/app -e AWS_REGION=${AWS_REGION} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN) infoblox/helm:3.2.4-5b243a2' 
alias hl='helm list'
alias hls='helm list'
alias hli='helm lint'
alias hd='helm delete'
alias hi='helm install'
