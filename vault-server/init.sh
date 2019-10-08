#! /bin/bash

expected_num_vault_servers=$(terraform output "vault_cluster_size")

aws_region=$(terraform output "aws_region")
cluster_tag_key=$(terraform output "vault_servers_cluster_tag_key")
cluster_tag_value=$(terraform output "vault_servers_cluster_tag_value")

instances=$(aws ec2 describe-instances --region "$aws_region" \
--filter "Name=tag:$cluster_tag_key,Values=$cluster_tag_value" "Name=instance-state-name,Values=running")

list_instances=($(echo "$instances" | jq -r '.Reservations[].Instances[].PublicIpAddress'))

VAULT_ADDR="https://${list_instances[0]}:8200"
VAULT_INIT=$(VAULT_ADDR=$VAULT_ADDR vault operator init -key-shares=5 -key-threshold=3 -format=json)

for instance in "${list_instances[@]}"; do
  VAULT_ADDR="https://$instance:8200"
  VAULT_ADDR=$VAULT_ADDR vault operator unseal "$(echo $VAULT_INIT | jq -r .unseal_keys_b64[0])"
  VAULT_ADDR=$VAULT_ADDR vault operator unseal "$(echo $VAULT_INIT | jq -r .unseal_keys_b64[1])"
  VAULT_ADDR=$VAULT_ADDR vault operator unseal "$(echo $VAULT_INIT | jq -r .unseal_keys_b64[2])"
done

VAULT_ADDR=$VAULT_ADDR vault status

VAULT_ADDR=$VAULT_ADDR vault login "$(echo $VAULT_INIT | jq -r .root_token)"

echo "Make an: export VAULT_ADDR=https://$(terraform output vault_endpoint)"
