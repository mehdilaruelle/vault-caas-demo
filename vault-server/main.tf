module "vault" {
  source  = "hashicorp/vault/aws"
  version = "0.13.3"

  ami_id             = "${var.ami_id}"
  ssh_key_name       = "${var.key_name}"
  vault_cluster_size = "${var.cluster_size}"
}

# Configure assume role to permit Vault to use AWS EC2 auth method
data "aws_iam_policy_document" "aws_ec2_auth_method" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vault" {
  name_prefix = "vlt-ec2-auth-method-"
  role        = "${module.vault.iam_role_id_vault_cluster}"
  policy      = "${data.aws_iam_policy_document.aws_ec2_auth_method.json}"

  lifecycle {
    create_before_destroy = true
  }
}
