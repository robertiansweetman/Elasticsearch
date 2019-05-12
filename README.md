# Elasticsearch
Automatically bring up Docker running Elasticsearch on a Debian virtualmachine using Terraform

NOTE: environment specific secrets are pulled from Modules/Shared/credentials/credentials.tf

Whatever user you reference in the credentials.tf needs to be able to access and create artifacts on vSphere for this to work

Using ESXi is another option BUT this requires an ESXi license (£500) to gain access to the API's which Terraform uses. 

ESXi and vSphere have **different defaults** when it comes to folder, networking and routing. Annoyingly they use the same provider calls to log in so there will likely be the need to have a *different* set of credentials or ElasticSearch.tf setup file to cope with this...  
