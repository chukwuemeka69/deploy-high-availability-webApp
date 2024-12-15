#!/bin/bash

# Function to execute CloudFormation commands with common options
deploy_or_delete() {
  local action="$1"
  local stack_name="$2"
  local template_file="$3"
  local parameters_file="$4"
  local region="$5"

  if [[ "$action" == "deploy" ]]; then
    echo "Deploying stack '$stack_name' with template '$template_file' and parameters '$parameters_file' in region '$region'..."
    aws cloudformation create-stack \
      --stack-name "$stack_name" \
      --template-body file://"$template_file" \
      --parameters file://"$parameters_file" \
      --capabilities "CAPABILITY_NAMED_IAM" \
      --region "$region" > deploy.log 2>&1 || {
        echo "Error: Failed to deploy stack '$stack_name'! Check 'deploy.log' for details." >&2
        return 1
      }
    echo "Stack '$stack_name' deployed successfully."
  elif [[ "$action" == "delete" ]]; then
    echo "Deleting stack '$stack_name' in region '$region'..."
    aws cloudformation delete-stack \
      --stack-name "$stack_name" \
      --region "$region" > delete.log 2>&1 || {
        echo "Error: Failed to delete stack '$stack_name'! Check 'delete.log' for details." >&2
        return 1
      }
    echo "Stack '$stack_name' deletion initiated."
  fi
}

# Menu for user selection
while true; do
  echo "\n=============================================================================="
  echo "Menu for creation and deletion of stack"
  echo "------------------------------------------------------------------------------"
  echo "Please enter a number to select your choice:"
  echo "------------------------------------------------------------------------------"
  echo "(1) Create stack network"
  echo "(2) Create webApp Server and Bastion host"
  echo "(3) Delete Stack WebApp and Bastion host"
  echo "(4) Delete stack network"
  echo "(5) Quit"
  echo "------------------------------------------------------------------------------"
  read -p "Enter your choice: " choice

  case "$choice" in
    1)
      read -p "Enter template file for network stack: " template_file
      read -p "Enter parameters file for network stack: " parameters_file
      read -p "Enter AWS region: " region
      if [[ ! -f "$template_file" ]]; then
        echo "Error: Template file '$template_file' not found."
        continue
      fi
      if [[ ! -f "$parameters_file" ]]; then
        echo "Error: Parameters file '$parameters_file' not found."
        continue
      fi
      deploy_or_delete deploy "udagram-Network" "$template_file" "$parameters_file" "$region"
      ;;
    2)
      read -p "Enter template file for webApp and Bastion host stack: " template_file
      read -p "Enter parameters file for webApp and Bastion host stack: " parameters_file
      read -p "Enter AWS region: " region
      if [[ ! -f "$template_file" ]]; then
        echo "Error: Template file '$template_file' not found."
        continue
      fi
      if [[ ! -f "$parameters_file" ]]; then
        echo "Error: Parameters file '$parameters_file' not found."
        continue
      fi
      deploy_or_delete deploy "udagram-webApp" "$template_file" "$parameters_file" "$region"
      ;;
    3)
      read -p "Enter AWS region: " region
      deploy_or_delete delete "udagram-webApp" "" "" "$region"
      ;;
    4)
      read -p "Enter AWS region: " region
      deploy_or_delete delete "udagram-Network" "" "" "$region"
      ;;
    5)
      echo "Exiting the script. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
  esac

done