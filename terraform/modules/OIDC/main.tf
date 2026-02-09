data "tls_certificate" "this" {
  url = var.oidc_provider_url
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = var.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
}
