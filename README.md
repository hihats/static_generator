## description
This container features is to generate static files (including html, css, javascript and image files) for CMS dynamically accesses server per user requests.
It would be helpful for web site built on lower specification server.

### option
It replaces all http links into https links for web ssl works.

## specification
```
$ docker build -t hihats/static_generator .

# in case to check in local machine
$ docker run --rm hihats/static_generator $ORIGIN_URL

# push image to ECR
$ docker tag hihats/static_generator:latest ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/hihats/static_generator:latest
$ docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/hihats/static_generator:latest
```

### ECSのタスクとして登録
- clusterが無い場合は作成
```
$ aws ecs create-cluster --cluster-name ${site_name}_fargate_cluster
```

- task登録
```
$ aws ecs register-task-definition
  --family static_generator
  --task-role-arn arn:aws:iam::****:role/ecs_task_execution_role
  --execution-role-arn arn:aws:iam::****:role/ecs_task_execution_role
  --network-mode awsvpc
  --container-definition '[
            {
                "name": "static_generator",
                "image": "****.dkr.ecr.ap-northeast-1.amazonaws.com/hihats/static_generator:latest",
                "cpu": 512,
                "memoryReservation": 512,
                "portMappings": [],
                "essential": true,
                "command": [
                    "origin.url.com"
                ],
                "environment": [
                    {
                        "name": "S3_BUCKET",
                        "value": "origin.url.com"
                    }
                ],
                "mountPoints": [],
                "volumesFrom": [],
                "logConfiguration": {
                    "logDriver": "awslogs",
                    "options": {
                        "awslogs-group": "/ecs/static_generator",
                        "awslogs-region": "ap-northeast-1",
                        "awslogs-stream-prefix": "ecs"
                    }
                }
            }
        ]'
  --cpu 512
  --memory 1024

```

- Task Definition(container difinition)のCOMMANDに引数を設定すると、entrypointの引数になる

### environmental variables
```
S3_BUCKET=BUCKET NAME
DISTRIBUTION_ID=CLOUDFRONT DISTRIBUTION ID
```

### run task regularly
ECSクラスター画面のタスクのスケジューリングで定期実行の設定をする

### run task manually
```
$ aws ecs run-task --task-definition static_generator --cluster arn:aws:ecs:ap-northeast-1:****:cluster/${site_name}-static-generator --launch-type FARGATE --network-configuration "awsvpcConfiguration={subnets=[subnet-****],securityGroups=[sg-****],assignPublicIp=DISABLED}"
```
