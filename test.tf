provider "aws" {
  region     = "${var.region}"
#  profile    = "${var.profile}"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

# variable "vpc_id" {}

# data "aws_vpc" "selected" {
#  id = "${var.vpc_id}"
# }

resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}


data "aws_availability_zones" "all" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"
}


resource "aws_security_group" "sg" {
  name = "terraform-sg"

#  vpc_id   = "${var.vpc_id}"

vpc_id   = "${aws_default_vpc.default.id}"

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

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#resource "aws_instance" "example_a" {
#  ami           = "ami-2757f631"
#  ami           = "ami-bf4193c7"
#  ami           = "ami-b469e6cc"
#  ami           = "ami-223f945a"
#  instance_type = "t2.micro"
#  availability_zone = "us-west-2a"
#  security_groups   = ["terraform-sg"]
#  vpc_id 	    = "${aws_vpc.vpc.id}"
#  vpc_id	    = "${var.vpc_id}"
#  subnet_id 	    = "96aa46df"
#  key_name = "test2"

#  tags {
#    Name = "Server A - httpd bash"
#  }

#  connection {
#    user = "ec2-user"
#    private_key="${file("/Users/Nick/Downloads/test2.pem")}"
#}

 # provisioner "remote-exec" {
#   inline = [
# "sudo echo 'test' > /home/ec2-user/user-script-output.txt",
# "export PATH=$PATH:/usr/bin",
#  "sudo yum -y update",
# "sudo yum -y install httpd",
# "sudo touch /var/www/html/index.html",
# "sudo chmod ugo+w /var/www/html/index.html",
#  "sudo echo 'Server A' > /var/www/html/index.html",
#  "sudo systemctl enable httpd",
#  "sudo service httpd start",
# "sudo chkconfig httpd on"
#  ]
#   }


# user_data = <<HEREDOC
#  #!/bin/bash
  #echo 'test' > /home/ec2-user/user-script-output.txt
  #yum -y install httpd
  #echo "Server A" > index.html
#  echo "Hello, World" > /var/www/html/index.html
#  systemctl enable httpd
#  service httpd start
#  chkconfig httpd on
# HEREDOC
#}


resource "aws_instance" "example_b" {
#  ami           = "ami-2757f631"
#  ami           = "ami-bf4193c7"
#  ami           = "ami-b469e6cc"
  ami           = "ami-223f945a"
  instance_type = "t2.micro"
  availability_zone = "us-west-2b"
  security_groups   = ["terraform-sg"]

  key_name = "test2"

  tags {
    Name = "Server B - httpd bash"
  }

  connection {
    user = "ec2-user"
    private_key="${file("/Users/Nick/Downloads/test2.pem")}"
}

  provisioner "remote-exec" {
   inline = [
 "sudo echo 'test' > /home/ec2-user/user-script-output.txt",
 "export PATH=$PATH:/usr/bin",
# "sudo yum -y update",
 "sudo yum -y install httpd",
 "sudo touch /var/www/html/index.html",
 "sudo chmod ugo+w /var/www/html/index.html",
 "sudo echo 'Server B' > /var/www/html/index.html",
 "sudo systemctl enable httpd",
 "sudo service httpd start",
 "sudo chkconfig httpd on",
  ]
   }


 # user_data = <<HEREDOC
  #!/bin/bash
  #echo 'test b' > /home/ec2-user/user-script-output.txt
  #yum -y install httpd
#  systemctl enable httpd
#  service httpd start
#  chkconfig httpd on
# HEREDOC
}

data "template_file" "user_data" {
  template = "${file("user_data.yml")}"
}

resource "aws_instance" "example_c" {
#  ami           = "ami-2757f631"
#  ami           = "ami-bf4193c7"
#  ami           = "ami-b469e6cc"
  ami           = "ami-223f945a"
  instance_type = "t2.micro"
  availability_zone = "us-west-2c"
  security_groups   = ["terraform-sg"]

  key_name = "test2"

  tags {
    Name = "Server C - bash"
  }

#  user_data = <<HEREDOC
#  #cloud-boothook
#  #!/bin/bash
#  export PATH=$PATH:/usr/bin
#  touch /home/ec2-user/user-script-output.txt
#  echo 'Test c' > /home/ec2-user/user-script-output.txt
#  sudo yum -y install httpd
#  sudo systemctl enable httpd
#  sudo service httpd start
#  sudo chkconfig httpd on
##cloud-config
# runcmd:
# - touch /tmp/test.txt
# HEREDOC

# user_data = <<HEREDOC
#  #!/bin/bash
  # yum update -y
#  export PATH=$PATH:/usr/bin
#  touch /home/ec2-user/user-script-output.txt
#  touch /test.txt
#  sudo yum install -y httpd
#  sudo service httpd start
#  sudo chkconfig httpd on
  # echo "?>" >> /var/www/html/calldb.php
# HEREDOC

#user_data = <<-EOF
#              #!/bin/bash
#              touch /tmp/test.txt
	      # echo "Hello, World" > index.html
              # nohup busybox httpd -f -p 8080 &
#              EOF

# user_data = ${file("example.txt")}

user_data = "${data.template_file.user_data.rendered}"

# provisioner "local-exec" {
#   command = "./script.sh" }
}


resource "aws_elb" "example" {
  name = "terraform-elb-example"
#  security_groups = ["terraform-sg"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
#  instances                   = ["i-0fdff02403e7bc66e","i-0e7c3c4d6ef699b17"]
# instances                   = ["${aws_instance.example_a.id}","${aws_instance.example_b.id}"]

# instances                   = ["example_a","example_b"]

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







resource "aws_launch_configuration" "asg" {
  image_id = "ami-223f945a"
  instance_type = "t2.micro"
 # security_groups = ["${aws_security_group.instance.id}"]
  security_groups = ["terraform-sg"]
  key_name = "test2"
# user_data = <<HEREDOC
  #!/bin/bash
#  echo 'test' > /home/ec2-user/user-script-output.txt
#  sudo yum -y install httpd
#  sudo touch /var/www/html/index.html
#  sudo chmod ugo+w /var/www/html/index.html
#  sudo echo 'Hello, World' > /var/www/html/index.html
#  sudo systemctl enable httpd
#  sudo service httpd start
#  sudo chkconfig httpd on
# HEREDOC


#user_data = <<HEREDOC
#cloud-config
# package_upgrade: true
# packages:
# - nfs-utils
# - httpd
# runcmd:
# - echo "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).file-system-id.efs.aws-region.amazonaws.com:/    /var/www/html/efs-mount-point   nfs4    defaults" >> /etc/fstab
# - mkdir /var/www/html/efs-mount-point
# - mount -a
# - touch /var/www/html/efs-mount-point/test.html
# - service httpd start
# - chkconfig httpd on

# HEREDOC

user_data = "${data.template_file.user_data.rendered}"



 # user_data = <<-EOF
              #!/bin/bash
              #echo "Hello, World" > index.html
              #nohup busybox httpd -f -p "${var.server_port}" &
#              EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.asg.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 4

#  key_name = "test2"

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}
