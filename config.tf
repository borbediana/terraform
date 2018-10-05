variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-3"
}


provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_s3_bucket" "bucket-example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "diana-getting-started"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami           = "ami-075b44448d2276521"
  instance_type = "t2.micro"
  depends_on = ["aws_s3_bucket.bucket-example"]

  # like Ansible
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}
/*
resource "aws_instance" "example2" {
  ami           = "ami-0bda2f719350708b7"
  instance_type = "t2.micro"
}*/

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

