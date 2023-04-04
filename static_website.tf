provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "domain"
  website = true
  index_document = "index.html"
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.bucket
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::website/*"
      ]
    }
  ]
}
EOF
}

data "aws_route53_zone" "example" {
  name = "domain_name"
}

resource "aws_route53_record" "website_domain" {
  name            = "domain_name"
  type            = "A"
  hosted_zone_id  = data.aws_route53_zone.example.zone_id
  alias {
    name            = aws_s3_bucket.website.bucket_regional_domain_name
    zone_id         = "Z3AQBSTGFYJSTF"
    evaluate_target_health = false
  }
}

resource "aws_route53_hosted_zone" "website" {
  name = "domain_name"
}
