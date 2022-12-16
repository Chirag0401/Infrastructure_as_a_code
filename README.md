# Three-Tier-Infra as a code
This repo is contains terraform and packer code

Getting started
To get the infra running on aws:

Clone this repo
change directory terraform/dev
terraform init
terraform plan -out <file_name>
terraform apply <file_name>

To build image for nodejs backend
packer init
packer validate main.json
packer build main.json

Code Overview
Dependencies

terraform - https://developer.hashicorp.com/terraform/cli/install/apt
packer - https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

Application Structure
terraform/ - This folder contains terraform code to create thee-tier-infra in AWS.
packer/ - This folder contains the code to create image for the backend i.e node js application.

Authentication
You can export secret and access key to .env file and map the variables in provider.tf
