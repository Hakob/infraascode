#!/usr/bin/env bash
# -*- coding: utf-8 -*-
if [ $1 = "plan" ] | [ $1 = "apply" ]
then
    key_path="${HOME}/.ssh/created_by_terraform"
    yes y | ssh-keygen -q -b 4096 -t rsa -N "" -f $key_path -C "terraform_iac"
    export TF_VAR_privkey_path=$key_path
    export TF_VAR_pubkey_path="${key_path}.pub"
    cd terraform/
    terraform $1
elif [ $1 = "destroy"]
then
    key_path="${HOME}/.ssh/terraform_provisioned"
    echo "Deleting key-pair"
    if [ -d "$key_path" ]; then
      rm $TF_VAR_privkey_path
      rm $TF_VAR_pubkey_path
    fi
    cd terraform/
    terraform $1
else
  echo "Invalid argument. Valid ones are: [plan|apply|destroy]"
fi

# ansible_home="../ansible"
# echo "[front]" > $ansible_home/frontend.ini
# terraform output -json front-ips | jq -r '.[]' >> $ansible_home/frontend.ini
# echo "[back]" > $ansible_home/backend.ini
# terraform output -json back-ips | jq -r '.[]' >> $ansible_home/backend.ini
