### AWS CLI Windows Download Link: `https://awscli.amazonaws.com/AWSCLIV2.msi`
- `aws --version` #to check AWS Version

### Some AWS CLI Samples
```
- aws ec2 run-instances --image-id ami-0a91cd140a1fc148a --instance-type t2.micro --count 1 --key-name kul-ericsson-thinknyx #Create Instances
- aws ec2 create-tags --resources i-0cc21eeb319725187 --tags Key=Name,Value=thinknyx-kul # Add Tags on existing Resources
- aws ec2 run-instances --image-id ami-0a91cd140a1fc148a --instance-type t2.micro --count 1 --key-name kul-ericsson-thinknyx --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=thinknyx-kul}]' 'ResourceType=volume,Tags=[{Key=Name,Value=thinknyx-kul}]' # Create instance with Tags on Instance & Volume
- aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul"
```
### Powershell Sample to Fetch only Instance IDs
```
- (aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul" | ConvertFrom-Json).Reservations.Instances.InstanceId
```
### Powershell Sample to Delete Instance using Ids
```
$instanceIds = (aws ec2 describe-instances --filters "Name=tag:Name,Values=thinknyx-kul" | ConvertFrom-Json).Reservations.Instances.InstanceId
foreach($id in $instanceIds){
    Write-Host "[INFO] Deleting $id"
    aws ec2 terminate-instances --instance-ids $id
}
```
