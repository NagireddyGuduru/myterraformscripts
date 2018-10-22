output "vpc_id" {
  value = "${aws_vpc.myapp_vpc.id}"
}

output "subnet_ids" {
  value = "${aws_subnet.web_subnets.*.id}"
}

output "subnet_azs" {
  value = "${aws_subnet.web_subnets.*.availability_zone}"
}
