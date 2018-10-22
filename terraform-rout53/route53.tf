resource "aws_route53_record" "www" {
  zone_id = "Z10M7CVVLZ3926"
  name    = "jobassistonline.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.myapp_elb.dns_name}"
    zone_id                = "${aws_elb.myapp_elb.zone_id}"
    evaluate_target_health = false
  }
}
