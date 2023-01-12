task: write terraform scripts that will create the infrastructure needed to provide a continuous-integration pipeline for a dockerized app run on AWS ECS behind an Application Load Balancer

resources needed:

ECR repo
CodePipeline
    - source: GitHub (Version 2)
        - App exists on Github with authorization to read source repo
        - "GitHub App connection" is required in AWS (not sure if creation can be scripted)
    - build: AWS CodeBuild 
        - Build Project
    -deploy: Amazon ECS
        - cluster defined below
        - service defined below
ECS
    - Cluster
    - Task Definition
        - type: Fargate
        - operating system: linux
        -Task role not required
        -task execution role - select newly created one (details in IAM below)
        -task memory and cpu dynamically set by input variables?, default to 8gb 2cpu
        - container definition
            -image should point to ECR repo with a tag of "Latest"
            - port mappings determined by script input, default to none
            -auto configure cloudwatch logs
            - everything else default
        - add volume, bind mount ok
    - Service
        - launch type: fargate, operating system linux
        - task defition: previously defined task definition
        - number of tasks, healthy percent, max percent: defined by script input. defaults: 1, 100, 200
        - deployment type: rolling update
        - all else default
        - VPC, subnets, security groups: create new (listed below)
        - Load Balancing
            - application load balancer (should exist already)
            - add container to load balancer
                - production listener port: 443
                - target group name: create new. naming schema: {AppName}TargetGroup
                - target group protocol: HTTP
                - path pattern: /
                - evaluation order: 1
                - health check path: /

EC2
    - Application Load Balancer
        - will already be configured with SSL cert configured via AWS Certificate Manager (ACM)
    - security group
        - auto created via ECS service, leave wide open for now

IAM
    - Create new ECS task execution role 
        -1 policy attached: AmazonECSTaskExecutionRolePolicy 
    - Create new policy for code build to be able to upload docker image to ECR repo. Named ECRForCodeBuild - policy JSON at bottom of this document
    - Assign ECRForCodeBuild policy to auto-created build project service role
    - Optionally allow for creation of IAM user with programmatic access only, if app needs api key (not sure how best to implement this, might not make sense for terraform)



ECRForCodeBuild json:

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}