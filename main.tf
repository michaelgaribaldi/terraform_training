#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-2df66d3b
#
# Your subnet ID is:
#
#     subnet-fe40a9a4
#
# Your security group ID is:
#
#     sg-4cc10432
#
# Your Identity is:
#
#     testing-panther
#

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "us-east-1"
} 
variable "num_webs" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami = "ami-2df66d3b"

  instance_type = "t2.micro"

  subnet_id = "subnet-fe40a9a4"

  vpc_security_group_ids = ["sg-4cc10432"]

  tags {
    "Identity" = "testing-panther"
    "Name" = "web ${count.index+1} / ${var.num_webs}"
  }

  count = "${var.num_webs}"
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

terraform {
  backend "atlas" {
    name	= "mgaribaldi/training"
  }
}
