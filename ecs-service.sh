#!/bin/bash

creds=`aws secretsmanager get-secret-value --secret-id terraform --region us-west-1 --query SecretString| jq ".SecretString|fromjson"`

CLUSTER_NAME=`echo $creds | jq -r ".cluster_name"`
REGION=`echo $creds | jq -r ".region"`
API_TARGET_GROUP_ARN=`echo $creds | jq -r ".api_target_group_arn"`
ADMIN_TARGET_GROUP_ARN=`echo $creds | jq -r ".admin_target_group_arn"`
SERVICE_BEAT_NAME=`echo $creds | jq -r ".service_beat_name"`
SERVICE_WORKER_NAME=`echo $creds | jq -r ".service_worker_name"`
SERVICE_API_NAME=`echo $creds | jq -r ".service_api_name"`
SERVICE_ADMIN_NAME=`echo $creds | jq -r ".service_admin_name"`
TD_BEAT_NAME=`echo $creds | jq -r ".td_beat_name"`
TD_WORKER_NAME=`echo $creds | jq -r ".td_worker_name"`
TD_API_NAME=`echo $creds | jq -r ".td_api_name"`
TD_ADMIN_NAME=`echo $creds | jq -r ".td_admin_name"`
CONTAINER_BEAT_NAME=`echo $creds | jq -r ".container_beat_name"`
CONTAINER_WORKER_NAME=`echo $creds | jq -r ".container_worker_name"`
CONTAINER_API_NAME=`echo $creds | jq -r ".container_api_name"`
CONTAINER_ADMIN_NAME=`echo $creds | jq -r ".container_admin_name"`
API_TARGET_GROUP_ARN=`echo $creds | jq -r ".api_target_group_arn"`
ADMIN_TARGET_GROUP_ARN=`echo $creds | jq -r ".admin_target_group_arn"`


service_exists() {
  local service_name=$1

  local describe_output
  describe_output=$(aws ecs describe-services \
    --cluster $CLUSTER_NAME \
    --services $service_name \
    --region us-east-1 2>&1)

  if [ $? -ne 0 ]; then
    echo "Error checking service existence: $describe_output"
    return 1
  fi


  if echo "$describe_output" | grep -q '"services": \[\]'; then
    return 1
  else
    return 0
  fi
}

create_or_update_ecs_service() {
  local service_name=$1
  local task_definition=$2
  local desired_count=$3
  local container_name=$4
  local container_port=$5
  local target_group_arn=$6

  if service_exists $service_name; then
    echo "Updating existing service: $service_name"
    aws ecs update-service \
      --cluster IRS-Test2 \
      --service $service_name \
      --task-definition $task_definition \
      --desired-count $desired_count \
      --region us-east-1 \
      --force-new-deployment
  else
    echo "Creating new service: $service_name"
    if [ "$service_name" == "$SERVICE_BEAT_NAME" ] || [ "$service_name" == "$SERVICE_WORKER_NAME" ]; then

      aws ecs create-service \
        --cluster $CLUSTER_NAME \
        --service-name $service_name \
        --task-definition $task_definition \
        --desired-count $desired_count \
        --launch-type "EC2" \
        --region $REGION
    else
    
      aws ecs create-service \
        --cluster $CLUSTER_NAME \
        --service-name $service_name \
        --task-definition $task_definition \
        --desired-count $desired_count \
        --launch-type "EC2" \
        --load-balancers "targetGroupArn=$target_group_arn,containerName=$container_name,containerPort=$container_port" \
        --health-check-grace-period-seconds 30 \
        --region $REGION
    fi
  fi
}

create_or_update_ecs_service "$SERVICE_BEAT_NAME" "$TD_BEAT_NAME" 1
create_or_update_ecs_service "$SERVICE_WORKER_NAME" "$TD_WORKER_NAME" 1
create_or_update_ecs_service "$SERVICE_API_NAME" "$TD_API_NAME" 2 "$CONTAINER_API_NAME" 8000 "$API_TARGET_GROUP_ARN"
create_or_update_ecs_service "$SERVICE_ADMIN_NAME" "$TD_ADMIN_NAME" 1 "$CONTAINER_API_NAME" 8000 "$ADMIN_TARGET_GROUP_ARN"