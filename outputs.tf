# output "aws_instance_public_dns" {
#   value = aws_instance.nginx[count.index].public_dns
# }

output "aws_alb_public_dns" {
  value = aws_lb.nginx.dns_name
}