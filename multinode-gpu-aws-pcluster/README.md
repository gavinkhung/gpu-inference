# AWS ParallelCluster v3

## Examples

[Parallel Cluster Docs](https://docs.aws.amazon.com/parallelcluster/latest/ug/tutorials-v3.html)

[NVIDIA CUDA Examples](https://github.com/NVIDIA/multi-gpu-programming-models)

## Usage

More information about the parallel cluster CLI is [here](https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-configuring.html)

```sh
cd envs/test
python3 -m pip install --user --upgrade virtualenv
python3 -m virtualenv venv
source venv/bin/activate

pip3 install awscli
pip3 install aws-parallelcluster
```

Sign into AWS CLI with a key pair

```sh
aws configure
```

Generate a EC2 key pair, allowing us to SSH into the parallel cluster

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

Create a configuration file in `us-east-1`. Use a GPU instance, like `g4dn.xlarge`

```sh
pcluster configure --config cluster-config.yaml
```

Create the cluster

```sh
pcluster create-cluster --cluster-name dev-cluster --cluster-configuration cluster-config.yaml --region us-east-1

pcluster describe-cluster --cluster-name dev-cluster --region us-east-1

pcluster list-clusters --region us-east-1
```

SSH into the cluster

```sh
chmod 400 pcluster_key_pair.pem
pcluster ssh --cluster-name dev-cluster --region us-east-1 -i pcluster_key_pair.pem
```

Test to see if CUDA is installed.

```sh
nvidia-smi

module avail

module load openmpi
```

Submit a Slurm job to test OpenMPI

```sh
# download and compile files
sbatch submit.sh
watch squeue
```

After running the job, delete the created EC2 instances

```sh
pcluster delete-cluster-instances --cluster-name dev-cluster --region us-east-1
```

Clean up the cluster

```sh
pcluster delete-cluster --cluster-name dev-cluster --region us-east-1

pcluster list-clusters --region us-east-1

terraform destroy
```

## Troubleshooting

### Delete CloudFormation Stack

If you created a config file, but don't want to use it anymore. Make sure you deleted any resources it created using:

```sh
aws cloudformation delete-stack --stack-name parallelclusternetworking-XXXXXXXX
```

Find the cloudformation stacks [here](https://us-west-1.console.aws.amazon.com/cloudformation/home#/stacks)

### Cancel Slurm Job

Assuming you previously started a job

```sh
sbatch job.sh
```

Cancel the job

```sh
squeue -u $USER
scancel 123456
```
