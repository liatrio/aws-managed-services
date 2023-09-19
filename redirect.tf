locals {
  s3_website_endpoint_zone_id = var.s3_website_endpoint_zone_ids[var.aws_region]
}

resource "aws_route53_zone" "private" {
  count = var.create_redirect ? 1 : 0
  name  = var.route53_hosted_zone_name

  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
    }
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to vpcs, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      vpc,
    ]
  }

  tags = var.aws_route53_zone_tags
}

resource "aws_route53_record" "s3_alias" {
  count   = var.create_redirect ? 1 : 0
  name    = aws_s3_bucket.amg_bucket[0].bucket
  type    = "A"
  zone_id = aws_route53_zone.private[0].zone_id

  alias {
    name                   = aws_s3_bucket_website_configuration.amg_bucket_website[0].website_endpoint
    zone_id                = local.s3_website_endpoint_zone_id
    evaluate_target_health = false
  }
}

# tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "amg_bucket" {
  count  = var.create_redirect ? 1 : 0
  bucket = "grafana.${var.route53_hosted_zone_name}"
}

resource "aws_s3_bucket_public_access_block" "amg_bucket" {
  count                   = var.create_redirect ? 1 : 0
  bucket                  = aws_s3_bucket.amg_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "amg_bucket_website" {
  count  = var.create_redirect ? 1 : 0
  bucket = aws_s3_bucket.amg_bucket[0].bucket

  redirect_all_requests_to {
    host_name = var.amg_redirect_hostname
  }
}
