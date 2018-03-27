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
# vpc_id = "${var.vpc_id}"
# }

resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}


"te" 197L, 3992C
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
"test.tf" 324L, 7121C
    to_port = 80

 📂  ~/workarea/github/terraform   master ✹ ❓ 
👉 ls                                                                         ⌚ 10:26PM
README.md                terraform.tfstate        user_data.yml
sample.txt               terraform.tfstate.backup user_data.yml.bak
script.sh                test.tf                  variables.tf
te                       test.tf.bak

 📂  ~/workarea/github/terraform   master ✹ ❓ 
👉 vivim te                                                                    ⌚ 10:26PM

 📂  ~/workarea/github/terraform   master ✹ ❓ 
👉 vim test.tf                                                                ⌚ 10:27PM

 📂  ~/workarea/github/terraform   master ✹ ❓ 
👉 clear                                                                      ⌚ 10:29PM
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
"test.tf" 324L, 7151C
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
