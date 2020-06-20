resource "aws_s3_bucket" "frontend_bucket" {
  bucket_prefix = "${var.appname}-"
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject"
        ],
        "Resource": "${aws_s3_bucket.frontend_bucket.arn}/*",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.my_access_identity.id}"
        }
      }
    ]
  }
  EOF
}

resource "aws_s3_bucket" "log-bucket" {
  bucket_prefix = "${var.appname}-cloud-front-logs"
  force_destroy = true
}

data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.buildDir
  output_path = "output.zip"

}
resource "null_resource" "web_upload" {
  triggers = {
    src_hash = data.archive_file.init.output_sha
  }
  provisioner "local-exec" {
    command = "aws --profile cygni s3 sync ${var.buildDir} s3://${aws_s3_bucket.frontend_bucket.bucket}"
  }

  provisioner "local-exec" {
    command = "aws --profile cygni cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} --paths '/*'"
  }
}

resource "aws_cloudfront_origin_access_identity" "my_access_identity" {
  comment = "access-identity-${var.appname}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = aws_cloudfront_origin_access_identity.my_access_identity.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.my_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
    "PUT"]
    cached_methods = [
      "GET",
      "HEAD",
    "OPTIONS"]
    target_origin_id = aws_cloudfront_origin_access_identity.my_access_identity.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 84000
  }

  enabled             = true
  default_root_object = "index.html"
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.log-bucket.bucket_domain_name
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [
        "SE",
      "GB"]
    }
  }
}


