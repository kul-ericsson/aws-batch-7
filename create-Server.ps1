$imageDetails = aws ec2 describe-images --filters Name="tag:Name",Values="ericsson-batch-5-ubuntu-image" | ConvertFrom-Json
$amiID = $imageDetails.Images.ImageId

$keyPairs = aws ec2 describe-key-pairs | ConvertFrom-Json

foreach($keyPair in $keyPairs.KeyPairs){
    if ($keyPair.KeyName -match "ericsson"){
        $keyName = $keyPair.KeyName
    }
}

$serverInfo = aws ec2 run-instances --image $amiID --key-name $KeyName --instance-type "t2.micro" 

write-host "[INFO] Some Deployment"
Write-Host "[INFO] Some Testing"

sleep 40

foreach($instance in ($serverInfo | ConvertFrom-Json).Instances){
    aws ec2 terminate-instances --instance-ids $instance.InstanceId
}

foreach($instance in (aws ec2 describe-instances | ConvertFrom-Json).Reservations.Instances){
    aws ec2 terminate-instances --instance-ids $instance.InstanceId
}

foreach( $vol in (aws ec2 describe-volumes | ConvertFrom-Json).Volumes.VolumeId){
    aws ec2 delete-volume --volume-id $vol
}

# AWS S3 Bucket Commands

aws s3 ls
aws s3 mb s3://thinknyx-ericsson-batch-5
aws s3 rb s3://thinknyx-ericsson-batch-5
aws s3 ls s3://thinknyx-ericsson-batch-5
aws s3 ls s3://thinknyx-ericsson-batch-5 --recursive
aws s3 cp .\Attendence.xlsx s3://thinknyx-ericsson-batch-5/attendence.xlsx
aws s3 cp .\create-Server.ps1 s3://thinknyx-ericsson-batch-5/scripts/

# Commands for CloudFormation Stacks

foreach($stack in (aws cloudformation describe-stacks | ConvertFrom-Json).Stacks){
    aws cloudformation delete-stack --stack-name $stack.StackName
}