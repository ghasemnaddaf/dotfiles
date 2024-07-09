alias tp='tsh kube --proxy=${TELEPORT_PROXY}'
alias tpls='tp ls'
alias tpli='tp login --set-context-name'
func tplogin() {
   local cluster=$1
   local user=$1
   if ! tpli $cluster $user; then
	   echo "failed to teleport to $cluster/$user via ${TELEPORT_PROXY} list of available clusters:"
	   tpls
   fi
}
alias tp2='tplogin env-2a'
alias tp4='tplogin env-4'
alias tp5='tplogin env-5'
alias tpp='tplogin prd-1'
alias tp0='tpp'
alias tps='tplogin stg-1'
alias tpdd='tplogin ddi-dev-use1'
alias tpd5='tpdd'
alias tpdq='tplogin ddi-qa-use1'
alias tpd2='tpdq'
alias tpd2a='tpd2'
alias tpd4='tplogin ddi-qa-ase1'
alias tpb4='tplogin box-4'
