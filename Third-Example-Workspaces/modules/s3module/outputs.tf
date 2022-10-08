# Bucket Object
output "web_bucket" {
    value=aws_s3_bucket.web_bucket
}

# Instance PRofile Object

output "instance_profile" {
    value = aws_iam_instance_profile.instance_profile
    
}