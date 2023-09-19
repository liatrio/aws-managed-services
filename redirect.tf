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
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
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
    protocol  = "https"
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.amg_bucket_website.website_endpoint
    origin_id   = "S3Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer" # Fetch from S3 with the same protocol as viewer used.
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  enabled         = true
  is_ipv6_enabled = false
  price_class     = "PriceClass_100"

  default_cache_behavior {
    # Using the Managed-CachingOptimized (recommended for S3) managed policy ID:
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = ""
    # cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
