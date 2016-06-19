#!/bin/bash
## These commands assume us-east-1 is the default region for the aws cli, and that everything is in us-east-1
## If you are doing this in a different region, you will need to look up the hosted zone id for s3 website in your zone
##  at http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region (scroll down and get the s3 website endpoints)

## Also, you probably want to change the index.html that's included here, or in other ways change how you're loading content to the site
## (but honestly, putting the content in the bucket is the easiest part of all this)

aws s3api create-bucket --bucket www.$1 --region us-east-1
aws s3api create-bucket --bucket $1 --region us-east-1
aws s3 cp index.html s3://$1/index.html
cat policy.json | sed -e "s/example\.com/$1/g" > temp.json
aws s3api put-bucket-policy --bucket $1 --policy file://temp.json
aws s3 website s3://$1/ --index-document index.html
aws route53 create-hosted-zone --name $1 --caller-reference "auto-script-$(($(date +%s%N)/1000000))" > hosted-zone.json
grep -Po '"Location":.*?[^//]",' hosted-zone.json | perl -pe 's/"Location"://; s/^.*hostedzone\///; s/",$//;' > hosted-zone.id
HOSTED_ZONE_ID=`cat hosted-zone.id`

cat alias.json | sed -e "s/example\.com/$1/g" > temp.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://temp.json
cat alias.json | sed -e "s/example\.com/www.$1/g" > temp.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://temp.json

echo ""
echo "Remaining tasks:"
echo "1. Set up S3 Website Redirection on www.$1 to $1 (S3 Console)"
echo "2. Change name servers based upon below response"
echo "3. Profit!"
echo ""
cat hosted-zone.json
echo ""