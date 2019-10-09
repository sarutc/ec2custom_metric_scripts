
#!/usr/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s  http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
#USEDMEMORY=$(free -m | awk 'NR==2{printf "%.2f\t", $3*100/$2 }')
USEDMEMORY=$(free  | awk 'NR==2{print $3}')
FREEMEMORY=$(free  | awk 'NR==2{print $4}')
TCP_CONN=$(netstat -an | wc -l)
TCP_CONN_MYSQL_3306=$(netstat -an | grep :3306 | wc -l)
TCP_CONN_HTTP_80=$(netstat -an | grep :80 | wc -l)
TCP_CONN_HTTPS_443=$(netstat -an | grep :443 | wc -l)
TCP_CONN_REDIS_6379=$(netstat -an | grep :6379 | wc -l)
#USERS=$(uptime |awk '{ print $6 }')
IO_WAIT=$(iostat | awk 'NR==4 {print $5}')

if [[ ${TCP_CONN_REDIS_6379}  -gt 0 ]]; then
    aws --region $REGION cloudwatch put-metric-data --metric-name TCP_connection_REDIS_6379 --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $TCP_CONN_REDIS_6379
fi

if [[ ${TCP_CONN_MYSQL_3306}  -gt 0 ]]; then
    aws --region $REGION cloudwatch put-metric-data --metric-name TCP_connection_MYSQL_3306 --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $TCP_CONN_MYSQL_3306
fi

if [[ ${TCP_CONN_HTTP_80}  -gt 0 ]]; then
    aws --region $REGION cloudwatch put-metric-data --metric-name TCP_connection_HTTP_80 --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $TCP_CONN_HTTP_80
fi

if [[ ${TCP_CONN_HTTPS_443}  -gt 0 ]]; then
    aws --region $REGION cloudwatch put-metric-data --metric-name TCP_connection_HTTPS_443 --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $TCP_CONN_HTTPS_443
fi

aws --region $REGION cloudwatch put-metric-data --metric-name memory-usage --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $USEDMEMORY --unit Kilobytes
aws --region $REGION cloudwatch put-metric-data --metric-name memory-free --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $FREEMEMORY --unit Kilobytes
aws --region $REGION cloudwatch put-metric-data --metric-name Tcp_connections --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $TCP_CONN
aws --region $REGION cloudwatch put-metric-data --metric-name IO_WAIT --dimensions Instance=$INSTANCE_ID  --namespace "EC2-Custom" --value $IO_WAIT
