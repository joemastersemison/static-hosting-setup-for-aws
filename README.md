# static-hosting-setup-for-aws
Script to set up static hosting on AWS S3 for root and www subdomains with default content

These commands assume us-east-1 is the default region for the aws cli, and that everything is in us-east-1. If you are doing this in a different region, you will need to look up the hosted zone id for s3 website in your zone at [AWS docs](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region) (scroll down and get the s3 website endpoints)

Also, you probably want to change the index.html that's included here, or in other ways change how you're loading content to the site (but honestly, putting the content in the bucket is the easiest part of all this).