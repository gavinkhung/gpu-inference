# AWS Sagemaker Notebook

Create a Jupyter notebook instance on AWS Sagemaker and a S3 bucket to house data. Training jobs on Sagemaker read in and output data using AWS S3 Buckets.

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

As a safety measure, you have to manually make sure that the bucket is empty before deleting it, including all of the versions of each file.
Click [here for the AWS Console](https://us-west-1.console.aws.amazon.com/s3/buckets?region=us-west-1&bucketType=general)

```sh
terraform destroy
```

## Upload Files to S3 Bucket

```sh
cd /home/ec2-user/SageMaker/

aws s3 cp file.txt s3://bucket-name/dir/

# upload whole dir to S3 bucket
aws s3 cp local_dir/ s3://bucket-name/dir/ --recursive

# sync a local dir with a dir in a S3 bucket. uploads necessary files
aws s3 sync local_dir/ s3://bucket-name/dir/
```

## Download Files from S3 Bucket

```sh
cd /home/ec2-user/SageMaker/

aws s3 ls s3://bucket-name/dir/

aws s3 cp s3://bucket-name/remote_file.txt file.txt

# download whole dir in S3 bucket
aws s3 cp s3://bucket-name/dir/ local_dir/ --recursive

# sync a S3 bucket dir with a local dir. downloads necessary files
aws s3 sync s3://bucket-name/dir/ local_dir/
```
