# GPU AWS EC2 instance

SSH into a single or multi-GPU EC2 instance.

## Examples

- [single_gpu.py](https://github.com/pytorch/examples/blob/main/distributed/ddp-tutorial-series/single_gpu.py)
- [multigpu_torchrun.py](https://github.com/pytorch/examples/blob/main/distributed/ddp-tutorial-series/multigpu_torchrun.py)

## Prerequisites

This assumes that the user is logged into AWS, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

```sh
brew install awscli
aws configure
```

## Create EC2 Instance with Terraform

Create EC2 Instance

```sh
cd envs/test
terraform init
terraform plan
terraform apply -auto-approve
```

It might take some time to initialize. This must complete before you can SSH into the instance.

```sh
aws ec2 describe-instance-status --instance-ids i-1234567890abcdef0
```

SSH into instance. The username to SSH into will vary depending on the AMI.

```sh
chmod 400 private-key.pem

ssh ec2-user@PUBLIC_IP -i private-key.pem
ssh ubuntu@PUBLIC_IP -i private-key.pem
```


Shutdown the instance

```sh
sudo umount /mnt/data
exit

terraform destroy
```

## Verify GPU and Cuda

Check NVIDIA GPU existence/usage

```sh
nvidia-smi
```

Check Cuda installation

```sh
nvcc --version
```

Verify Cuda is accessible in PyTorch and Docker can access GPUs. Look at the latest Docker PyTorch images [here](https://hub.docker.com/r/pytorch/pytorch/tags)

```sh
docker pull pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime
docker run --gpus all --rm pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime python3 -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('Device count:', torch.cuda.device_count())"
```

The commands assume that the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) is installed in the AMI. If they aren't already there, follow the commands on their installation guide to allow Docker to access GPUs.

## Move Data to EC2

```sh
mkdir local_dataset_dir
echo "hello" > local_dataset_dir/a.txt
scp -i private-key.pem -r local_dataset_dir/ ubuntu@PUBLIC_IP:/home/ubuntu/data
```

## Move Data from EC2

```sh
scp -r -i private-key.pem ubuntu@PUBLIC_IP:/home/ubuntu/data/ remote_dataset_dir/
```

## Mounting the EBS volume

Depending on the type of hard drives, they will be named differently. So use `lsblk`.

nvme devices are typically named `dev/nvme[1-26]n1`

xvdf or sdx devices could be in the format of `/dev/xvdh`, `/dev/xvdg`, or `/dev/sdX`

List available block devices on ec2 instance:

```sh
lsblk
```

Look at the mounted filesystems

```sh
df -h
```

Depending on the commands above, the following commands might have to be changed. The commands do the following:

1. Format the volume
2. Create directory for the mounted volume
3. Mount the volume to the directory
4. Persist the mounted volume

### Mount xvdf Device

```sh
sudo mkfs.ext4 /dev/xvdh
sudo mkdir -p /mnt/data
sudo mount /dev/xvdh /mnt/data
sudo echo '/dev/xvdh /mnt/data ext4 defaults,nofail 0 0' >> /etc/fstab
```

### Mount nvme Device

```sh
sudo mkfs.ext4 /dev/nvme1n1
sudo mkdir -p /mnt/data
sudo mount /dev/nvme1n1 /mnt/data
sudo echo '/dev/nvme1n1 /mnt/data ext4 defaults,nofail 0 0' >> /etc/fstab
```

### Verify EBS Volume Mount

Use the following commmands to see if the EBS Volume is mounted to `/mnt/data`

```sh
df -h
lsblk
```

Let's use the newly mounted volume

```sh
sudo chown $USER:$USER /mnt/data
echo "Hello, EBS Volume" > /mnt/data/test.txt
cat /mnt/data/test.txt
```

## Connect to Jupyter Notebook

```sh
jupyter notebook --ip=* --no-browser --port=8888

PUBLIC_IP:8888/?token=<your-token-here>
```
