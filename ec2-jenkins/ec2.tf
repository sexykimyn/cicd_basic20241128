provider "aws" {
    region = "us-west-1"
}

variable "vpc_id" {
    default = "vpc-0bcf7e4ba79e92607"
}

resource "aws_security_group" "sg" {
    name = "saju-ap-sg-dev"
    description = "saju api sg dev"
    vpc_id = var.vpc_id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "APP"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "saju-api-sg-dev"
        Service = "saju-dev"
    }
}

resource "aws_instance" "ec2" {
    ami = "ami-018a1ea25ff5268f0"
    instance_type = "t2.micro"
    key_name = "saju-key-dev"
    vpc_security_group_ids = [aws_security_group.sg.id]
    availability_zone = "us-west-1a"
    user_data = file("./userdata.sh")
    
    root_block_device {
        volume_size = 30
        volume_type = "gp3"
    }

    tags = {
        Name = "saju-api-dev"
        Service = "saju-dev"
    }
}

resource "aws_eip" "eip" {
    instance = aws_instance.ec2.id
    
    tags = {
        Name = "saju-api-dev"
        Service = "saju-dev"
    }
}

output "eip_ip" {
    value = aws_eip.eip.public_ip
}