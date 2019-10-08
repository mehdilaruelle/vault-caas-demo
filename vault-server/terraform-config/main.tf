# Root CA
resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  default_lease_ttl_seconds = 31536000
  max_lease_ttl_seconds     = 31536000
}

resource "vault_pki_secret_backend_root_cert" "root" {
  backend = "${vault_mount.pki.path}"

  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = "31536000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  ou                   = "ff"
  organization         = "Final Fantasy"
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = "${vault_mount.pki.path}"
  issuing_certificates    = ["http://127.0.0.1:8200/v1/pki/ca"]
  crl_distribution_points = ["http://127.0.0.1:8200/v1/pki/crl"]
}

# Intermediate CA
resource "vault_mount" "intermediate" {
  path                      = "pki_int"
  type                      = "pki"
  default_lease_ttl_seconds = "${var.int_lease}"
  max_lease_ttl_seconds     = "${var.int_max_lease}"
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  backend = "${vault_mount.intermediate.path}"

  type        = "internal"
  common_name = "${var.domain}"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "root" {
  backend = "${vault_mount.pki.path}"

  csr                  = "${vault_pki_secret_backend_intermediate_cert_request.intermediate.csr}"
  common_name          = "${var.int_common_name}"
  exclude_cn_from_sans = true
  ou                   = "${var.int_ou}"
  organization         = "${var.int_org}"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend = "${vault_mount.intermediate.path}"

  certificate = "${vault_pki_secret_backend_root_sign_intermediate.root.certificate}"
}

# Enable AWS auth method
resource "vault_auth_backend" "aws" {
  type = "aws"
  path = "aws"
}

# Policies application
resource "vault_pki_secret_backend_role" "role" {
  backend = "${vault_mount.intermediate.path}"

  name             = "${var.entity_name}"
  allowed_domains  = ["${var.domain}"]
  allow_subdomains = true
  ttl              = "${var.certificate_ttl}"
  max_ttl          = "${var.certificate_max_ttl}"
}

data "template_file" "web_policies" {
  template = "${file("${var.policy_path}")}"

  vars = {
    role_name = "${var.entity_name}"
    pki_path  = "${vault_mount.intermediate.path}"
  }
}

resource "vault_policy" "web_policies" {
  name = "${var.entity_name}"

  policy = "${data.template_file.web_policies.rendered}"
}
