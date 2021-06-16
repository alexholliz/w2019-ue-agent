# w2019-ue-agent

<https://alexanderhollis.com/aws/packer/windows/unreal/2021/06/12/building-an-unreal-4-game-build-agent-ami-with-packer.html>

This repo takes the instructions for building an AMI as described in that blog post, and adds Github Actions to automatically build a Windows Server 2019 Unreal Engine 4 AMI.

## Prereqs

Github Repository Secrets for your: 
* AWS Packer IAM Access Key ID
* AWS Packer IAM Secret Access Key
* AWS S3 IAM Access Key ID
* AWS S3 IAM Secret Access Key
* VPC ID
* Subnet ID
* AWS Region
* S3 Bucket
* Unreal Engine Version

## Actions

The Actions file sets a few environment variables to use your repository secrets, and uses the Packer actions from Hashicorp: <https://github.com/marketplace/actions/packer-github-actions>

It also has some extra logic to avoid Github Actions timeouts. This thing takes like 90 minutes to run.

```
          AWS_MAX_ATTEMPTS: 90
          AWS_POLL_DELAY_SECONDS: 60
```

Below is the main.yml for the Actions workflow, but the breakdown is:

- Run on: Push and Manual start

- Job called "Packer"

1. Sync code from repo
2. Do a packer validate with secrets as environment variables
3. Do a packer build with secrets as environment variables

```
# This is a basic workflow to help you get started with Actions

name: Packer

# Controls when the action will run. 
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    paths:
      - 'packer/**'

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  packer:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2

      # validate templates
      - name: Validate Template
        uses: hashicorp/packer-github-actions@master
        with:
          command: validate
          arguments: -syntax-only
          target: ./packer/packer.pkr.hcl
        env:
          PKR_VAR_aws_region: ${{ secrets.AWS_REGION }}
          PKR_VAR_vpc_id: ${{ secrets.VPC_ID }}
          PKR_VAR_subnet_id: ${{ secrets.SUBNET_ID }}
          PKR_VAR_AKID: ${{ secrets.PACKER_IAM_AKID }}
          PKR_VAR_SKEY: ${{ secrets.PACKER_IAM_SKEY }}
          PKR_VAR_S3_AKID: ${{ secrets.S3_IAM_AKID }}
          PKR_VAR_S3_SKEY: ${{ secrets.S3_IAM_SKEY }}
          PKR_VAR_S3_BUCKET: ${{ secrets.S3_BUCKET }}
          PKR_VAR_UNREAL_ENGINE_VERSION: ${{ secrets.UNREAL_ENGINE_VERSION }}

      # build artifact
      - name: Build Artifact
        uses: hashicorp/packer-github-actions@master
        with:
          command: build
          arguments: "-color=false -on-error=cleanup"
          target: ./packer/packer.pkr.hcl
        env:
          PACKER_LOG: 1
          PKR_VAR_aws_region: ${{ secrets.AWS_REGION }}
          PKR_VAR_vpc_id: ${{ secrets.VPC_ID }}
          PKR_VAR_subnet_id: ${{ secrets.SUBNET_ID }}
          PKR_VAR_AKID: ${{ secrets.PACKER_IAM_AKID }}
          PKR_VAR_SKEY: ${{ secrets.PACKER_IAM_SKEY }}
          PKR_VAR_S3_AKID: ${{ secrets.S3_IAM_AKID }}
          PKR_VAR_S3_SKEY: ${{ secrets.S3_IAM_SKEY }}
          PKR_VAR_S3_BUCKET: ${{ secrets.S3_BUCKET }}
          PKR_VAR_UNREAL_ENGINE_VERSION: ${{ secrets.UNREAL_ENGINE_VERSION }}
          AWS_MAX_ATTEMPTS: 90
          AWS_POLL_DELAY_SECONDS: 60
```