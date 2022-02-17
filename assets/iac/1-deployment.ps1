# What we will be doing in this script.
#   1. Create a resource group
#   2. Deploy Azure services

########## Set before deployment, do not save to repository ##########
$usersPassword = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
######################################################################

# Update these according to the environment
$subscriptionName = "Visual Studio Enterprise"
$resourceGroupName = "rg-lessons-learned-from-implementing-api-management-visug"
$basePath = "C:\Users\elder\OneDrive\Sessions\Lessons-Learned-From-Implementing-API-Management-In-The-Real-World"
$administratorEmail = "me@eldert.net"

# Login to Azure
Get-AzSubscription -SubscriptionName $subscriptionName | Set-AzContext

# Retrieves the dynamic parameters
$administratorObjectId = (Get-AzADUser -Mail $administratorEmail).Id

# Create the resource group and deploy the resources
New-AzResourceGroup -Name $resourceGroupName -Location 'West Europe' -Tag @{CreationDate=[DateTime]::UtcNow.ToString(); Project="Lessons Learned From Implementing API Management In The Real World"; Purpose="Session"} -Force
New-AzResourceGroupDeployment -Name "APIMLessonsLearned" -ResourceGroupName $resourceGroupName -TemplateFile "$basePath\assets\iac\azuredeploy.json" -usersPassword $usersPassword -administratorObjectId $administratorObjectId

# Optional for debugging, loops through each local file individually
#Get-ChildItem "$basePath\assets\iac" -Filter *.json | 
#Foreach-Object {
#    Write-Output "Deploying: " $_.FullName
#   New-AzResourceGroupDeployment -Name Demo -ResourceGroupName $resourceGroupName -TemplateFile $_.FullName -ErrorAction Continue
#}