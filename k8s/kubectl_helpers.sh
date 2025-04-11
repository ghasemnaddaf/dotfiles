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
  echo "ENDPOINT-ID                         UNIVERSAL-SERVICE-ID                CSP-ACCOUNT-ID"
  echo "-----------------------------------------------------------------------------------------------------------------"
  yq -r '.items[] | .spec.endpointId + "    " + .spec.universalServiceId + "    " + .spec.cspAccountId' - <<< "$epcs" | sort
}

alias qlep="list_all_endpoints"


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

alias helm='docker run --rm -v $PWD:/app -e AWS_REGION=${AWS_REGION} -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} -e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} infoblox/helm:3'
alias hl='helm list'
alias hls='helm list'
alias hli='helm lint'
alias hd='helm delete'
alias hi='helm install'

alias unsetaws='unset AWS_SESSION_TOKEN AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_ACCESS_KEY_ID'
