# GPU AWS EC2 instance

## Create EC2 Instance with Terraform

Create and SSH into instance

```sh
cd envs/test
terraform init # downloads aws provider
terraform plan
terraform apply -auto-approve

chmod 400 private-key.pem

ssh ec2-user@PUBLIC_IP -i private-key.pem
```

Shutdown the instance

```sh
sudo umount /mnt/data

terraform destroy
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
