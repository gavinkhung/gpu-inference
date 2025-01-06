# AWS Sagemaker Notebook

Create a Jupyter notebook instance on AWS Sagemaker

## Prerequisites

This assumes that the user is logged into AWS, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

```sh
brew install awscli
aws configure
```

## Create Notebook Instance with Terraform

Create Notebook Instance

```sh
cd envs/test
terraform init
terraform plan
terraform apply -auto-approve
```

Navigate to the notebook url in the terraform output.

Shutdown the notebook

```sh
terraform destroy
```
