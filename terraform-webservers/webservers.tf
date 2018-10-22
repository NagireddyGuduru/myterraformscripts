# Create New Key pair

resource "aws_key_pair" "developer" {
  key_name   = "hari-aws"
  public_key = "${file("c:/Users/lenovo/hari-aws.pub")}"
}

# # Add 2 EC2 instances one in each public subnet
# resource "aws_instance" "webservers" {
#   count         = 2
#   ami           = "ami-5a8da735"
#   instance_type = "t2.micro"
#   subnet_id     = "${aws_subnet.web_subnets.*.id[count.index]}"
#
#   key_name  = "${aws_key_pair.developer.key_name}"
#   user_data = "${file("scripts/install_httpd.sh")}"
#
#   vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
#
#   tags {
#     Name = "Webserver-${count.index + 1}"
#   }
# }

# Add Security Group for Web servers

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all inbound http traffic"
  vpc_id      = "${aws_vpc.myapp_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
