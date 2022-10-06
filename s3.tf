# aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket = local.s3_bucket_name
  
  force_destroy = true

  tags = local.common_tags
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
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      }
    },
    {
      "Sid": "Stmt1665038380822",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
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
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      }
    }
  ]
}
    POLICY

  

}

# aws_bucket_acl
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.bucket
  acl    = "private"
}

# aws_S3_bucekt_object
# using for_each function / loop
resource "aws_s3_object" "website_content" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value
  source = ".${each.value}"

  tags = local.common_tags
}

# resource "aws_s3_bucket_object" "graphic" {
#   bucket = aws_s3_bucket.web_bucket.bucket
#   key    = "/website/Globo_logo_Vert.png"
#   source = "./website/Globo_logo_Vert.png"

#   tags = local.common_tags
# }

# aws_iam_role
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

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

  tags = local.common_tags
}
# aws_iam_role_policy
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
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
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF

}
# aws_iam_instance_profile
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}