#!/bin/zsh
HOST=$1
PORT=$2
INSTANCE_NAME=$(echo $HOST | cut -d'.' -f1) 
PROFILE=$(echo $HOST | cut -d'.' -f3 | sed s/admin/Admin/) 
REGION=$(echo $HOST | cut -d'.' -f4) 
INSTANCE_ID=$(aws ec2 describe-instances --profile=$PROFILE --region=$REGION --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=\"*$INSTANCE_NAME*\"" --query "Reservations[0].Instances[0].InstanceId" --output text)

aws ssm start-session --target=$INSTANCE_ID --profile=$PROFILE --region=$REGION --document-name AWS-StartSSHSession --parameters "portNumber=$PORT"