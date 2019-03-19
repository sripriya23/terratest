terraform {
  backend                   "s3" {
    bucket                = "table1dg-terraform"
    key                   = "terra/state"
    region                = "eu-central-1"
  }
}

provider "aws" {
  region                  = "eu-central-1"
}

provider "aws" {
  alias                   = "ap-south-1"
  region                  = "ap-south-1"
}

resource "aws_instance" "table1dgvm" {
  depends_on              = ["aws_instance.backend"]
  ami                     = "ami-09def150731bdbcc2"
  instance_type           = "t2.micro"
  key_name                = "table1dg"
  tags                    = {
    Name                  = "table-dg-fe"
  }

  lifecycle               = {
    create_before_destroy = true
  }
}

resource "aws_instance" "backend" {
  instance_type           = "t2.micro"
  provider                = "aws.ap-south-1"
  count                   = 1
  ami                     = "ami-0889b8a448de4fc44"
  timeouts                = {
    create                = "60m"
    delete                = "2h"
  }

  key_name                = "table1dg"
  tags                    = {
    Name                  = "tabledg-be"
  }
}

