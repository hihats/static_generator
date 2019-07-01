#!/bin/sh

set -eu

if [ "$1" = "" ]
then
    echo "[ERROR]: Argument error"
    exit 1
fi
ORIGIN_URL=$1

STATUS=$(curl -s ${ORIGIN_URL} -o /dev/null -w '%{http_code}\n')
if [ "$STATUS" = "200" ]
then
    wget --quiet http://${ORIGIN_URL}/sitemap.xml --output-document - | egrep -o "https?://[^<]+" | wget -i -
fi

wget -r -l2 --page-requisites -q http://${ORIGIN_URL}
aws s3 sync s3://${S3_BUCKET}/ s3://backup.${S3_BUCKET}/
grep -lr 'http://'${ORIGIN_URL} ./${ORIGIN_URL}/* | xargs -i sed -i {} -e 's#http://'${ORIGIN_URL}'#https://'${ORIGIN_URL}'#g'
aws s3 cp --recursive ./${ORIGIN_URL}/ s3://${S3_BUCKET}/
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --path '/*'
