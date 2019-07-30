#!/bin/sh

set -eu

if [ "$1" = "" ]
then
    echo "[ERROR]: Argument error"
    exit 1
fi
ORIGIN_URL=$1
SITEMAP_URL=http://${ORIGIN_URL}/sitemap-pt-post-`date +%Y-%m`.xml

STATUS=$(curl -s $SITEMAP_URL -o /dev/null -w '%{http_code}\n')
if [ "$STATUS" = "200" ]
then
    wget --quiet $SITEMAP_URL -O - \
      | grep "<loc>" \
      | egrep -o "https?://[^<]+" \
      | xargs -I{} echo "{} {}" \
      | sed -e s#http://${ORIGIN_URL}/## \
      | xargs -n 2 sh -c 'wget --no-parent -B ${ORIGIN_URL} -I $0 -p $1' && ls -la
fi

wget -r -l2 --page-requisites -q http://${ORIGIN_URL}

if [ "$S3_BUCKET" = "" ]
then
    echo "[ERROR]: environmental valuable error for S3"
    exit 1
fi
aws s3 sync s3://${S3_BUCKET}/ s3://backup.${S3_BUCKET}/
grep -lr 'http://'${ORIGIN_URL} ./${ORIGIN_URL}/* | xargs -i sed -i {} -e 's#http://'${ORIGIN_URL}'#https://'${ORIGIN_URL}'#g'
aws s3 cp --recursive ./${ORIGIN_URL}/ s3://${S3_BUCKET}/
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --path '/*'
