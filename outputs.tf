output "acm_certificate_arn" {
  value       = aws_acm_certificate.domain.arn
  description = "The ARN of the ACM Certificate created for the Subdomain."
}

output "zone_id" {
  value       = aws_route53_zone.zone.id
  description = "The id of the route53 zone created for the subdomain."
}