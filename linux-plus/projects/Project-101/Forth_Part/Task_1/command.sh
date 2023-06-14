IP=$(grep PrivateIpAddress info.json | head -n1 | cut -d'"' -f4)
sed -i "s/ec2-private_ip/$IP/g" terraform.tf
