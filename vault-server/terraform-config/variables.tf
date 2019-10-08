# MANDATORY
variable "entity_name" {
  description = "Entity name (ex: web)"
}

variable "policy_path" {
  description = "The path of the template policy"
}

# OPTIONS
variable "domain" {
  default     = "example.com"
  description = "The domain name you use for your intermediate certificate."
}

# Intermediate CA options
variable "int_lease" {
  default     = "2592000"
  description = "The lease TTL (seconds) of the Intermediate CA. Default: 30d"
}
variable "int_max_lease" {
  default     = "25920000"
  description = "The max lease TTL (seconds) of the Intermediate CA. Default: 300d"
}

variable "int_common_name" {
  default     = "Intermediate CA"
  description = "The common name of the Intermediate CA."
}

variable "int_common_name" {
  default     = "Intermediate CA"
  description = "The common name of the Intermediate CA."
}

variable "int_ou" {
  default     = "demo"
  description = "The OU of the Intermediate CA."
}

variable "int_org" {
  default     = "Nubuo"
  description = "The organization name of the Intermediate CA."
}

# Certificate role options
variable "certificate_ttl" {
  default     = "60"
  description = "TTL is like equal to 1 minute"
}

variable "certificate_max_ttl" {
  default     = "600"
  description = "Max TTL is like equal to 10 minute"
}
