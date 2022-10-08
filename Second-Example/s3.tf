module "web_app_s3" {
  source="./modules/s3module/"

  bucket_name= local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags=local.common_tags
}

# aws_S3_bucekt_object
# using for_each function / loop
resource "aws_s3_object" "website_content" {
  for_each = fileset ("./website/", "**")
  bucket = module.web_app_s3.web_bucket.id
  key    = each.value
  source = "./website/${each.value}"

  tags = local.common_tags
}

