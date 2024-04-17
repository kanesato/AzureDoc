# bash ./BICEP-fundamental/Bicep-fundermental/Bash/deployment.sh

location="japaneast"
subscriptionName="skaneshiro-worksubs-02"
resourceGroupName="bicep-fundermental-resourcegroup"

az group create --name $resourceGroupName --location $location --subscription $subscriptionName
