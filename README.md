### Links:
- AWS CLi for Windows: `https://awscli.amazonaws.com/AWSCLIV2.msi`
- AWS SDK for Java: `https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/home.html`
- Docker Hub `https://hub.docker.com/`

### Some AWS CLI Samples
```
- `aws --version`
- aws ec2 run-instances --image-id ami-0a91cd140a1fc148a --instance-type t2.micro --count 1 --key-name kul-ericsson-thinknyx #Create Instances
- aws ec2 create-tags --resources i-0cc21eeb319725187 --tags Key=Name,Value=thinknyx-kul # Add Tags on existing Resources
- aws ec2 run-instances --image-id ami-0a91cd140a1fc148a --instance-type t2.micro --count 1 --key-name kul-ericsson-thinknyx --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=thinknyx-kul}]' 'ResourceType=volume,Tags=[{Key=Name,Value=thinknyx-kul}]' # Create instance with Tags on Instance & Volume
- aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul"
```
### Powershell Sample to Fetch only Instance IDs & Public IP
```
- (aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul" | ConvertFrom-Json).Reservations.Instances.InstanceId
- (aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul" | ConvertFrom-Json).Reservations.Instances.PublicIpAddress
```
### Powershell Sample to Delete Instance using Ids
```
$instanceIds = (aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul" | ConvertFrom-Json).Reservations.Instances.InstanceId
foreach($id in $instanceIds){
    Write-Host "[INFO] Deleting $id"
    aws ec2 terminate-instances --instance-ids $id
}
```
### Installation Steps: Docker in Ubuntu
```
# sudo apt-get update -y
# sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-get update -y
# sudo apt-get install docker-ce docker-ce-cli containerd.io -y
# sudo chown ubuntu:ubuntu /var/run/docker.sock
# docker version
```
### Steps: Login to AWS ECR from Ubuntu EC2 Server
```
# sudo apt-get update -y
# sudo apt-get install -y awscli
# aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 554660509057.dkr.ecr.us-east-2.amazonaws.com
```
