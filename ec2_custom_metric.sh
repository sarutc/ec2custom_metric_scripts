#!/usr/bin/bash

echo "1. install json query"
sudo yum install -y jq

echo "2. create mem.sh custom metric to put-metric-data to cloudwatch"
curl -s https://raw.githubusercontent.com/sarutc/ec2custom_metric_scripts/master/mem.sh

echo "3. chmod +x mem.sh"
sudo chmod +x mem.sh

echo "4. create crontab run mem.sh every minute"
sudo crontab <<EOF
* * * * * /home/ec2-user/mem.sh
EOF
