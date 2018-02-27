provider "aws" {
#  access_key = ""
#  secret_key = ""
  region     = "us-west-2"
}

resource "aws_instance" "example_1" {
#  ami           = "ami-2757f631"
   ami		 = "ami-223f945a"
  instance_type = "t2.micro"
  key_name = "terra"

  user_data = <<-EOF
              #!/bin/bash
              echo "Server A" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "Server A"
  }
}

resource "aws_instance" "example_2" {
#  ami           = "ami-2757f631"
   ami           = "ami-223f945a"
  instance_type = "t2.micro"
  availability_zone = "us-west-2b"

  user_data = <<-EOF
              #!/bin/bash
              echo "Server B" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  key_name = "terra"

  tags {
    Name = "Server B"
  }
}

resource "aws_instance" "example_3" {
#  ami           = "ami-2757f631"
#  ami           = "ami-bf4193c7"
#  ami           = "ami-b469e6cc"
  ami           = "ami-223f945a"
  instance_type = "t2.micro"
  availability_zone = "us-west-2b"
  security_groups   = ["terraform-sg"]

#  user_data = <<-EOF
#              #!/bin/bash
#              echo "Server B" > index.html
#              nohup busybox httpd -f -p 8080 &
#              EOF
  key_name = "terra"

  tags {
    Name = "Server B - bash"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  #echo 'test' > /home/ec2-user/user-script-output.txt
  #yum -y install httpd
  systemctl enable httpd
  service httpd start
  chkconfig httpd on
 HEREDOC
}

resource "aws_instance" "example_4" {
#  ami           = "ami-2757f631"
#  ami           = "ami-bf4193c7"
#  ami           = "ami-b469e6cc"
  ami           = "ami-223f945a"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  security_groups   = ["terraform-sg"]

#  user_data = <<-EOF
#              #!/bin/bash
#              echo "Server B" > index.html
#              nohup busybox httpd -f -p 8080 &
#              EOF
  key_name = "terra"

  tags {
    Name = "Server A - httpd bash"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  #echo 'test' > /home/ec2-user/user-script-output.txt
  #yum -y install httpd
  #echo "Server A" > index.html
  echo "Hello, World" > /var/www/html/index.html
  systemctl enable httpd
  service httpd start
  chkconfig httpd on
 HEREDOC
}


resource "aws_security_group" "sg" {
  name = "terraform-sg"
  
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "all" {}

resource "aws_launch_configuration" "asg" {
  image_id = "ami-223f945a"
  instance_type = "t2.micro"
 # security_groups = ["${aws_security_group.instance.id}"]
 # security_groups = ["terraform-sg"]
  user_data = <<-EOF
              #!/bin/bash
              #echo "Hello, World" > index.html
              #nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.asg.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
 
  min_size = 2
  max_size = 6

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}




resource "aws_elb" "example" {
  name = "terraform-asg-example"
#  security_groups = ["terraform-sg"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
#  instances                   = ["i-0fdff02403e7bc66e","i-0e7c3c4d6ef699b17"]

   health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }



  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }



}


