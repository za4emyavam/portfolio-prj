#!/bin/bash

dnf install jq -y
cd /etc/amazon/ssm/
cp amazon-ssm-agent.json.template amazon-ssm-agent.json
jq '.Agent.UseDualStackEndpoint = true' amazon-ssm-agent.json > tmp.json && mv tmp.json amazon-ssm-agent.json
systemctl restart amazon-ssm-agent


dnf update -y
dnf install nginx unzip -y

systemctl start nginx
systemctl enable nginx

#Script for deploy
cat <<'INNEREOF' > /usr/local/bin/deploy.sh
#!/bin/bash
BUCKET="portfolio-prj-artifact-bucket/artifacts" 
FILE_KEY="site.zip"
WEB_DIR="/usr/share/nginx"

aws s3 cp s3://$BUCKET/$FILE_KEY /tmp/site.zip --region eu-central-1 --endpoint-url https://s3.dualstack.eu-central-1.amazonaws.com
unzip -q -o /tmp/site.zip -d $WEB_DIR/html_new

rm -rf $WEB_DIR/html_old
mv $WEB_DIR/html $WEB_DIR/html_old 2>/dev/null || true
mv $WEB_DIR/html_new $WEB_DIR/html

echo "Deployment complete."
rm -f /tmp/site.zip
INNEREOF

chmod +x /usr/local/bin/deploy.sh

/usr/local/bin/deploy.sh