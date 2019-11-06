#!/usr/bin/env bash
# -*- coding: utf-8 -*-
if [[ $1 == "apply" ]];
then
    key_path="${HOME}/.ssh/created_by_terraform"
    export TF_VAR_privkey_path=$key_path
    export TF_VAR_pubkey_path="${key_path}.pub"
    terraform plan -target=module.ec2_instance.aws_instance.front_instances > /tmp/tfout.put
    regex='([0-9]+) to change,'
    plan_to_change=`cat /tmp/tfout.put | grep -- 'Plan:\|to add,\|to change,\|to destroy'`
    [[ $plan_to_change =~ $regex ]]
    if [[ "${BASH_REMATCH[1]}" != "0" ]] || [[ ! -z "${BASH_REMATCH[1]}" ]]; then
      yes y | ssh-keygen -q -b 4096 -t rsa -N "" -f $key_path -C "terraform_iac";
    fi
elif [[ $1 == "destroy" ]];
then
    export TF_VAR_privkey_path="${HOME}/.ssh/terraform_provisioned"
    export TF_VAR_pubkey_path="${TF_VAR_privkey_path}.pub"
    if [ -f "$TF_VAR_privkey_path" ]; then
      echo "Deleting key-pair"
      rm $TF_VAR_privkey_path
      rm $TF_VAR_pubkey_path
    fi
else
  echo "Invalid argument. Valid ones are: [plan|apply|destroy]"
  exit
fi
cd terraform/
terraform $1

# ansible_home="../ansible"
# echo "[front]" > $ansible_home/frontend.ini
# terraform output -json front-ips | jq -r '.[]' >> $ansible_home/frontend.ini
# echo "[back]" > $ansible_home/backend.ini
# terraform output -json back-ips | jq -r '.[]' >> $ansible_home/backend.ini
