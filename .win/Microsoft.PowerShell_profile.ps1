function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }

Set-PSReadlineOption -BellStyle None

# az

function az-dev {
    $global:AKS_NAME = "side-sync-engine"
    $global:RG = "side-sync-engine"
    $global:SECOND_NODEPOOL_NAME = "e32sv3"
    $global:SECOND_NODEPOOL_VM_SIZE = "Standard_E32s_v3"
    $global:SUBSCRIPTION = "DEV_UIT_SIDE"
    az account set -s $SUBSCRIPTION
}

function az-prod {
    $global:AKS_NAME = "side-sync-engine"
    $global:RG = "side-sync-engine-rg"
    $global:SECOND_NODEPOOL_NAME = "e32sv3"
    $global:SECOND_NODEPOOL_VM_SIZE = "Standard_E32s_v3"
    $global:SUBSCRIPTION = "UIT_TCP_USSC_PRD"
    az account set -s $SUBSCRIPTION
}

# aks

function aks-nodepool-scale {
    az aks nodepool scale `
        --cluster-name $AKS_NAME `
        --name $2 `
        -g $RG `
        --node-count $1
        #TODO: default name to $SECOND_NODEPOOL_NAME
}

# k8s
function ns {
    $k8sctx = kubectl config current-context
    kubectl config set-context $k8sctx --namespace=$args
}

