# ==============================
# Azure Windows VM Deployment
# Resource Group: test-vnet
# Region: North Europe
# ==============================

# Variables
$resourceGroup = "test-vnet"
$location = "northeurope"
$vnetName = "vnet-northeurope"
$subnetName = "snet-northeurope-1"
$nsgName = "first-VM-nsg"
$publicIpName = "first-VM-ip"
$nicName = "first-VM-nic"
$vmName = "first-VM"
$adminUser = "azureuser"

Write-Host "Creating Resource Group..."
az group create `
    --name $resourceGroup `
    --location $location

Write-Host "Creating Virtual Network and Subnet..."
az network vnet create `
    --resource-group $resourceGroup `
    --name $vnetName `
    --subnet-name $subnetName `
    --address-prefix 10.0.0.0/16 `
    --subnet-prefix 10.0.1.0/24

Write-Host "Creating Network Security Group..."
az network nsg create `
    --resource-group $resourceGroup `
    --name $nsgName

Write-Host "Allowing RDP (3389) inbound..."
az network nsg rule create `
    --resource-group $resourceGroup `
    --nsg-name $nsgName `
    --name Allow-RDP `
    --priority 1000 `
    --protocol Tcp `
    --direction Inbound `
    --access Allow `
    --source-address-prefixes "*" `
    --source-port-ranges "*" `
    --destination-port-ranges 3389 `
    --destination-address-prefixes "*"

Write-Host "Creating Public IP..."
az network public-ip create `
    --resource-group $resourceGroup `
    --name $publicIpName

Write-Host "Creating Network Interface..."
az network nic create `
    --resource-group $resourceGroup `
    --name $nicName `
    --vnet-name $vnetName `
    --subnet $subnetName `
    --network-security-group $nsgName `
    --public-ip-address $publicIpName

Write-Host "Creating Windows Virtual Machine..."
az vm create `
    --resource-group $resourceGroup `
    --name $vmName `
    --nics $nicName `
    --image Win2022Datacenter `
    --admin-username $adminUser `
    --admin-password "DoNotReveal1234"

Write-Host "Deployment completed successfully."