variable "aws_region" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "AKID" {
  type = string
}

variable "SKEY" {
  type = string
}

variable "S3_BUCKET" {
  type = string
}

variable "UNREAL_ENGINE_VERSION" {
  type = string
}

variable "S3_AKID" {
  type = string
}

variable "S3_SKEY" {
  type = string
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
source "amazon-ebs" "packer-w2019-ue-agent" {
  access_key       = "${var.AKID}"
  secret_key       = "${var.SKEY}"
  ami_name         = "packer-w2019-ue-agent"
  communicator     = "winrm"
  force_deregister = true
  instance_type    = "c5.large"
  region           = "${var.aws_region}"
  source_ami_filter {
    filters = {
      architecture        = "x86_64"
      name                = "Windows_Server-2019-English-Full-ContainersLatest-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    # the "Amazon" ami owner
    owners = ["801119661308"]
  }
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = true
  }
  subnet_id      = "${var.subnet_id}"
  user_data_file = "./packer/scripts/autogenerated_password_https_bootstrap.txt"
  vpc_id         = "${var.vpc_id}"
  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "Administrator"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  sources = ["source.amazon-ebs.packer-w2019-ue-agent"]

  provisioner "powershell" {
    script = "./packer/scripts/disable_uac.ps1"
  }

  provisioner "powershell" {
    script = "./packer/scripts/packages.ps1"
  }

  provisioner "powershell" {
    script = "./packer/scripts/visual_studio.ps1"
  }

  provisioner "powershell" {
    script = "./packer/scripts/awscli.ps1"
  }

  provisioner "powershell" {
    environment_vars = ["BUCKET=${var.S3_BUCKET}", "UNREAL_ENGINE_VERSION=${var.UNREAL_ENGINE_VERSION}", "AWS_ACCESS_KEY_ID=${var.S3_AKID}", "AWS_SECRET_ACCESS_KEY=${var.S3_SKEY}", "AWS_DEFAULT_REGION=${var.aws_region}"]
    script           = "./packer/scripts/unreal_engine.ps1"
  }

  provisioner "powershell" {
    inline = ["C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SendWindowsIsReady.ps1 -Schedule", "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule", "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown"]
  }
}