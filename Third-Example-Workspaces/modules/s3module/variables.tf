# Bucket Name
variable "bucket_name" {
    type = string
    description = "Name of the s3 bucket"
}


# ELB Service Account arn
variable "elb_service_account_arn" {
    type= string
    description = "ARN of ELB service account"
}

# # Common Tags
variable "common_tags" {
    type= map(string)
    description = "Map of tags to be applied to all resources"
    default = {}
}