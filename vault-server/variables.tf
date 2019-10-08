variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Pac    ker template under examples/vault-consul-ami/vault-consul.json."
  type        = string
}

variable "key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this     cluster. Set to an empty string to not associate a Key Pair."
  type        = string
}

# Optional
variable "cluster_size" {
  description = "The number of Vault inside the cluster."
  default     = 2
}
