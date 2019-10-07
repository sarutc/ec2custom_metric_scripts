#!/usr/bin/bash
chmod +x mem.sh
sudo yum install -y jq

crontab <<EOF
* * * * * /home/ec2-user/mem.sh
EOF
