resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
  
  force_destroy = true

  tags = var.common_tags
}
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.bucket

  policy = <<POLICY
{
  "Id": "Policy1665038476132",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1665038249333",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/alb-logs/*",
      "Principal": {
        "AWS": "${var.elb_service_account_arn}"
      }
    },
    {
      "Sid": "Stmt1665038380822",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      }
    },
    {
      "Sid": "Stmt1665038472592",
      "Action": [
        "s3:GetBucketAcl"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      }
    }
  ]
}
    POLICY

#   tags = var.common_tags

}

# aws_bucket_acl
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.bucket
  acl    = "private"
}


resource "aws_iam_role" "allow_nginx_s3" {
  name = "${var.bucket_name}-allow_nginx_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.common_tags
}
# aws_iam_role_policy
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "${var.bucket_name}-allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
    }
  ]
}
EOF

}
# aws_iam_instance_profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.bucket_name}-nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = var.common_tags
}