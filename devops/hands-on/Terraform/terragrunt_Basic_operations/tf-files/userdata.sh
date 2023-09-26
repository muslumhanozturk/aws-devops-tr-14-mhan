#!/bin/bash
dnf update -y
dnf install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf -y install terraform
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.47.0/terragrunt_linux_amd64
mv terragrunt_linux_amd64 terragrunt
chmod u+x terragrunt
mv terragrunt /usr/local/bin/terragrunt
chown ec2-user:ec2-user /usr/local/bin/terragrunt