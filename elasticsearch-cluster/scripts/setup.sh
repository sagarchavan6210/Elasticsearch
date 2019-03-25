#!/bin/bash

set -e
set +xv ## Do not remove

info_n() { echo -e "\e[36m$@\e[0m" 1>&2 ; }
info() { echo "" ; info_n $* ; }
warn() { echo ""; echo -e "\e[33m$@\e[0m" 1>&2; }
die() { echo -e "\e[31m$@\e[0m" 1>&2 ; exit 1; }

function inputValidation(){

	# Get Region Name
	if [ $Region == 'neur' ]
	then
	  REGION_AZ="North Europe"
	  
	elif [ $Region == 'weur' ]
	then
	  REGION_AZ="West Europe"
	fi
}

function configureAz(){
      info "Configuring Az..."
      az login --service-principal -u ${client_id} -p ${client_secret} --tenant ${tenant_id}
      az account set --subscription $subscription_id
}

function GetStorageKEY(){
  configureAz
  info "Geting Storage KEY"
  ACCESS_KEY=`az storage account keys list --account-name $AZURE_STORAGE_ACCOUNT --resource-group $RESOURCEGROUP |grep -i "value" | head -1 | awk -F'"' '{print $4}'`

  if [[ -z $ACCESS_KEY ]]; then
    die "unable to get AZURE_STORAGE_ACCESS_KEY for $AZURE_STORAGE_ACCOUNT"
  fi

  info "Creating container: $CONTAINER"
  az storage container create -n "$CONTAINER" --account-key $ACCESS_KEY
  export AZURE_STORAGE_ACCESS_KEY=$ACCESS_KEY
}

function createtfvars(){  
  info "creating custom tfvars"
  echo """
      subscription_id = \"$subscription_id\"
      client_id       = \"$client_id\"
      client_secret   = \"$client_secret\"
      tenant_id       = \"$tenant_id\"
      location        = \"$REGION_AZ\"
      vm_username     = \"$vm_username\"
	""" > creds.tfvars
	GetStorageKEY
}

    
function run(){
  case $1 in
    "plan")
	  createtfvars
      terraform get
      terraform -v
      terraform init -backend-config "storage_account_name=$AZURE_STORAGE_ACCOUNT" -backend-config "container_name=$CONTAINER" -backend-config "key=escluster.tfstate" -backend-config "access_key=$AZURE_STORAGE_ACCESS_KEY" -force-copy
      terraform plan -var-file=reference.tfvars -var-file=creds.tfvars
    ;;
    "apply")
      createtfvars
      terraform get
      terraform init -backend-config "storage_account_name=$AZURE_STORAGE_ACCOUNT" -backend-config "container_name=$CONTAINER" -backend-config "key=escluster.tfstate" -backend-config "access_key=$AZURE_STORAGE_ACCESS_KEY" -force-copy
      echo yes| terraform apply -var-file=reference.tfvars -var-file=creds.tfvars
    ;;
    "destroy")
      #warn "destroy option is disabled"
       createtfvars
       terraform init -backend-config "storage_account_name=$AZURE_STORAGE_ACCOUNT" -backend-config "container_name=$CONTAINER" -backend-config "key=escluster.tfstate" -backend-config "access_key=$AZURE_STORAGE_ACCESS_KEY" -force-copy 
       echo yes| terraform destroy -var-file=reference.tfvars -var-file=creds.tfvars
  ;;
  *)
    die "unknown option $1"
  ;;
  esac
}

hostname=`hostname`
inputValidation
export BLOB_POSTFIX=infra
export AZURE_STORAGE_ACCOUNT="tfstatest"
export RESOURCEGROUP="estfstate-rg"
export CONTAINER="tfstate-escluster-$BLOB_POSTFIX"

info "#################################### Variable Details ##################################"

  info_n "AZURE_REGION          = $REGION_AZ"
  info_n "AZURE_STORAGE_ACCOUNT = $AZURE_STORAGE_ACCOUNT"
  info_n "CONTAINER             = $CONTAINER"
  info_n "RESOURCEGROUP         = $RESOURCEGROUP"
  info_n "SUBSCRIPTION_ID       = $subscription_id"
  info_n "HOSTNAME              = $hostname"

info "########################################################################################"

run $1
