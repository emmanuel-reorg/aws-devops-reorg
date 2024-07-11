resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.selected.zone_id 
  name    = "${var.environment}.${var.api_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}