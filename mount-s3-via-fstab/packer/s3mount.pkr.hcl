packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "s3mount" {
  region        = "us-east-1"
  source_ami    = "ami-020cba7c55df1f615" # Ubuntu 24.04 LTS in us-east-1 region
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "s3-mount"
}

build {
  sources = ["source.amazon-ebs.s3mount"]

  # https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-variables
  provisioner "shell" {
    environment_vars = [
      "URL_BASE=https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64"
    ]

    inline = [
      # make a Bash script exit immediately if any command fails (non-zero exit status).
      "set -e",

      # Disable interactive dialogs
      "echo set debconf to Noninteractive",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",

      # Download the Mountpoint for Amazon S3 .deb package,
      "wget $URL_BASE/mount-s3.deb -O /tmp/mount-s3.deb",

      # Install the .deb package,
      "sudo apt-get update",
      "sudo apt-get install -y /tmp/mount-s3.deb",

      # Verify installation,
      "mount-s3 --version",

      # Install GnuPG,
      "sudo apt-get update",
      "sudo apt-get install -y gnupg",

      # Download the Mountpoint public key,
      "wget https://s3.amazonaws.com/mountpoint-s3-release/public_keys/KEYS -O /tmp/KEYS",

      # Import the key,
      "gpg --import /tmp/KEYS",

      # Verify the key fingerprint,
      "gpg --fingerprint mountpoint-s3@amazon.com | grep '673F E406 1506 BB46 9A0E  F857 BE39 7A52 B086 DA5A'",

      # Download the signature file (for integrity check),
      "wget $URL_BASE/mount-s3.deb.asc -O /tmp/mount-s3.deb.asc",

      # Verify the downloaded package,
      "gpg --verify /tmp/mount-s3.deb.asc /tmp/mount-s3.deb"
    ]
  }
}