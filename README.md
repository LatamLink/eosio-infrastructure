## Kubernetes
Kubernetes description of EOSIO network infrastructure for LACChain

devops:
  build-eosio-docker    : Builds a new  production docker image
  publish-eosio-docker  : Publishes latest built docker image
  build-eosio-cdt-docker    : Builds a new  production docker image
  publish-eosio-cdt-docker  : Publishes latest built docker image

lacchain:  
  apply-lacchain  : Applies kubernetes configurations based on source files
  delete-lacchain : Deletes kubernetes configurations based on source files
