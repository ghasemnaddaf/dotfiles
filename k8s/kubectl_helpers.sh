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

alias helm='docker run --rm -v $PWD:/app -e AWS_REGION=${AWS_REGION} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} infoblox/helm:3'
alias hl='helm list'
alias hls='helm list'
alias hli='helm lint'
alias hd='helm delete'
alias hi='helm install'

alias unsetaws='unset AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID'

# kafka ui
kui () {
	ns=poseidon-kafka-ui
	pod=$(kubectl get pods -n $ns | tail -1 | awk '{print $1}')
	kubectl port-forward -n $ns $pod 8080
}

# ddiaas aliases
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

# mc: go install github.com/jonnylangefeld/kubectl-mc@latest
alias mc='kubectl mc'
alias mcls='mc -l'
alias mcd='mc -r ddi-dev'
alias mcq='mc -r ddi-qa'
alias mcs='mc -r ddi-stg'
alias mc0='mc -r ddi.\*prd'

# mc em
alias mcdem='mcd -n ddiaas-endpoint-manager'
alias mcqem='mcq -n ddiaas-endpoint-manager'
alias mcsem='mcs -n ddiaas-endpoint-manager'
alias mc0em='mc0 -n ddiaas-endpoint-manager'
alias mcdepc='mcdem get epc'
alias mcqepc='mcqem get epc'
alias mcsepc='mcsem get epc'
alias mc0epc='mc0em get epc'

# mc dns
alias mcddns='mcd -n ddiaas-dns-endpoint'
alias mcqdns='mcq -n ddiaas-dns-endpoint'
alias mcsdns='mcs -n ddiaas-dns-endpoint'
alias mc0dns='mc0 -n ddiaas-dns-endpoint'
alias mcddnsgpo='mcddns get pod'
alias mcqdnsgpo='mcqdns get pod'
alias mcsdnsgpo='mcsdns get pod'
alias mc0dnsgpo='mc0dns get pod'
alias mcddnsgpow='mcddns get pod -w'
alias mcqdnsgpow='mcqdns get pod -w'
alias mcsdnsgpow='mcsdns get pod -w'
alias mc0dnsgpow='mc0dns get pod -w'

# mc dhcp
alias mcddhcp='mcd -n ddiaas-dhcp-endpoint'
alias mcqdhcp='mcq -n ddiaas-dhcp-endpoint'
alias mcsdhcp='mcs -n ddiaas-dhcp-endpoint'
alias mc0dhcp='mc0 -n ddiaas-dhcp-endpoint'
alias mcddhcpgpo='mcddhcp get pod'
alias mcqdhcpgpo='mcqdhcp get pod'
alias mcsdhcpgpo='mcsdhcp get pod'
alias mc0dhcpgpo='mc0dhcp get pod'
alias mcddhcpgpow='mcddhcp get pod -w'
alias mcqdhcpgpow='mcqdhcp get pod -w'
alias mcsdhcpgpow='mcsdhcp get pod -w'
alias mc0dhcpgpow='mc0dhcp get pod -w'

# mc d
alias mcdd='mcd -n ddiaas-dataplane'
alias mcqd='mcq -n ddiaas-dataplane'
alias mcsd='mcs -n ddiaas-dataplane'
alias mc0d='mc0 -n ddiaas-dataplane'
alias mcdgpo='mcdd get pod'
alias mcqgpo='mcqd get pod'
alias mcsgpo='mcsd get pod'
alias mc0gpo='mc0d get pod'
alias mcdgpow='mcdd get pod -w'
alias mcqgpow='mcqd get pod -w'
alias mcsgpow='mcsd get pod -w'
alias mc0gpow='mc0d get pod -w'

# mc ads
alias mcdver='mcd -n atlas-app-def-system get version'
alias mcqver='mcq -n atlas-app-def-system get version'
alias mcsver='mcs -n atlas-app-def-system get version'
alias mc0ver='mc0 -n atlas-app-def-system get version'
alias mcdffo='mcd -n atlas-app-def-system get featureflagoverrides.terminus.infoblox.com'
alias mcqffo='mcq -n atlas-app-def-system get featureflagoverrides.terminus.infoblox.com'
alias mcsffo='mcs -n atlas-app-def-system get featureflagoverrides.terminus.infoblox.com'
alias mc0ffo='mc0 -n atlas-app-def-system get featureflagoverrides.terminus.infoblox.com'

# endpoint manager
alias qem='k -n ddiaas-endpoint-manager'
alias qemgepc='qem get epc'
alias qepc='qemgepc'
alias qepc1='qepc | awk "{print \$1}"'
alias qeml='qem logs'
alias qemx='qem exec -it'

# Function to get endpointId by universalServiceId
function qemepcusvc() {
  if [ -z "$1" ]; then
    echo "Error: universalServiceId argument is required"
    echo "Usage: qemepcusvc <universalServiceId> [<fields>]"
    return 1
  fi

  local usvcid="$1"
  local fields="$2"
  if [ -z "$fields" ]; then
    fields="endpointId,cspAccountId"
  fi
  if [[ "$fields" == "full" ]]; then
    qepc -o yaml | yq ".items[] | select(.spec.universalServiceId == \"$usvcid\")"
  elif [[ "$fields" == "id" || "$fields" == "name" ]]; then
    qepc -o yaml | yq ".items[] | select(.spec.universalServiceId == \"$usvcid\") | .spec.endpointId"
  else
    # eg endpointId,cspAccountId,ophId,availabilityZoneConfigs is transformed to .spec.endpointId,.spec.cspAccountId,.spec.ophId,.spec.availabilityZoneConfigs
    fields=$(echo "$fields" | sed 's/\([^,]*\)/.spec.\1/g')
    qepc -o yaml | yq ".items[] | select(.spec.universalServiceId == \"$usvcid\") | $fields"
  fi
}

# Function to list all endpoints with their cspAccountId and universalServiceId
function list_all_endpoints() {
  # Get all EPCs and extract their names, cspAccountId and universalServiceId
  local output=""

  # Use yaml output for consistent parsing
  local epcs=$(qepc -o yaml)

  # Check if there are any EPCs
  if [ -z "$epcs" ]; then
    echo "No EPCs found"
    return 1
  fi

  # Use yq to extract the relevant fields for each EPC
  echo "ENDPOINT-ID                         UNIVERSAL-SERVICE-ID                REALM       CSP-ACCOUNT-ID"
  echo "-----------------------------------------------------------------------------------------------------------------"
  yq -r '.items[] | .spec.endpointId + "    " + .spec.universalServiceId + "    " + .spec.realm + "     " + .spec.cspAccountId' - <<< "$epcs" | sort
}

alias qlep="list_all_endpoints"

