# Add VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.vpc_tenancy}"

  tags {
    Name  = "myapp_vpc"
    Batch = "Weekends"
  }
}

# Add 2 public subnets
resource "aws_subnet" "web_subnets" {
  count                   = "${length(var.web_subnets_cird)}"
  vpc_id                  = "${aws_vpc.myapp_vpc.id}"
  cidr_block              = "${var.web_subnets_cird[count.index]}"
  availability_zone       = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

# Add Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"

  tags {
    Name = "myapp-igw"
  }
}

# Add Route table for public subnets
resource "aws_route_table" "web_rt" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "myapp_web_rt"
  }
}

resource "aws_route_table_association" "web_rt_association" {
  count          = 2
  subnet_id      = "${aws_subnet.web_subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.web_rt.id}"
}

#  Setup Private subnets for RDS

# Add 2 private subnets
resource "aws_subnet" "rds_subnets" {
  count             = "${length(var.rds_subnets_cird)}"
  vpc_id            = "${aws_vpc.myapp_vpc.id}"
  cidr_block        = "${var.rds_subnets_cird[count.index]}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"

  tags {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}
