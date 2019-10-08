output "vault_endpoint" {
  value = "${module.vault.vault_elb_dns_name}"
}

output "aws_region" {
  value = "${module.vault.aws_region}"
}

output "vault_servers_cluster_tag_key" {
  value = "${module.vault.vault_servers_cluster_tag_key}"
}

output "vault_servers_cluster_tag_value" {
  value = "${module.vault.vault_servers_cluster_tag_value}"
}

output "vault_cluster_size" {
  value = "${module.vault.vault_cluster_size}"
}

output "ssh_key_name" {
  value = "${module.vault.ssh_key_name}"
}
