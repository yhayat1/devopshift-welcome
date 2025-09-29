terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    aws = {
      source = "hashicorp/aws"
      version = "6.14.1"    
    }
  }
}

provider "aws" {
    region = var.region
}

provider "time" {

}

resource "aws_security_group" "sg" {
    name        = "yossih-sg1"
    description = "yossih test sg"
    vpc_id      = "vpc-078bb26dd40822e7a"
  
    ingress {
        from_port   = 22
        to_port     = 22
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

# resource "time_sleep" "sleep_10s" {
#   create_duration = "10s"  # Wait for 10 seconds
# }

resource "aws_instance" "vm" {
    ami = "ami-01abb3b5c93add95c" # Amazon Linux 2 AMI in us-east-1
    instance_type = "t2.micro"
    subnet_id = "subnet-0beb255e0856cd2a8" 
    vpc_security_group_ids = [aws_security_group.sg.id]

    tags = {
        Name = "yossih-vm"
    }
}

resource "null_resource" "check_public_ip" {
    provisioner "local-exec" {
        command = <<EOT
        if [ -z "${aws_instance.vm.public_ip}" ]; then
            echo "ERROR: Public IP address was not assigned." >&2
            exit 1
        fi
        EOT
    }

    depends_on = [aws_instance.vm]
}