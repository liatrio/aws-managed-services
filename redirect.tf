resource "aws_route53_zone" "private" {
  name = var.route53_hosted_zone_name

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
  name    = aws_s3_bucket.amg_bucket.bucket
  type    = "A"
  zone_id = aws_route53_zone.private.zone_id

  alias {
    name                   = aws_s3_bucket_website_configuration.amg_bucket_website.website_domain
    zone_id                = local.s3_website_endpoint_zone_id
    evaluate_target_health = false
  }
}

# tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "amg_bucket" {
  bucket = "grafana.${var.route53_hosted_zone_name}"
}

resource "aws_s3_bucket_public_access_block" "amg_bucket" {
  bucket                  = aws_s3_bucket.amg_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "amg_bucket_website" {
  bucket = aws_s3_bucket.amg_bucket.bucket

  redirect_all_requests_to {
    host_name = var.amg_redirect_hostname
  }
}