## description
This container features is to generate static files (including html, css, javascript and image files) for CMS dynamically accesses server per user requests.
It would be helpful for web site built on lower specification server.

## specification
```
$ docker build -t hihats/static_generator .

# in case to check in local machine
$ docker run --rm hihats/static_generator $ORIGIN_URL

# push image to ECR
$ docker tag hihats/static_generator:latest ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/hihats/static_generator:latest
$ docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/hihats/static_generator:latest
```

### ECRのタスクとして登録
- Task DefinitionのCOMMANDに引数を設定すると、entorypointの引数になる

### environmental variables
```
S3_BUCKET=BUCKET NAME
DISTRIBUTION_ID=CLOUDFRONT DISTRIBUTION ID
```
