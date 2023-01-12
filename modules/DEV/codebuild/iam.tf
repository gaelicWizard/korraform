resource "aws_iam_role" "codebuildrole" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "codebuild.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "Allows CodeBuild to call AWS services on your behalf."
    force_detach_policies = false
    managed_policy_arns   = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
        "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    ]
    max_session_duration  = 3600
    name                  = "CodeBuildRole"

    inline_policy {
        name   = "CodeBuild"
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "logs:CreateLogGroup",
                            "logs:CreateLogStream",
                            "logs:PutLogEvents",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "*",
                        ]
                    },
                    {
                        Action   = [
                            "s3:PutObject",
                            "s3:GetObject",
                            "s3:GetObjectVersion",
                            "s3:GetBucketAcl",
                            "s3:GetBucketLocation",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "arn:aws:s3:::codepipeline-us-east-1-*",
                        ]
                    },
                    {
                        Action   = [
                            "lambda:GetAlias",
                            "lambda:ListVersionsByFunction",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "*",
                        ]
                    },
                    {
                        Action   = [
                            "cloudformation:GetTemplate",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "*",
                        ]
                    },
                    {
                        Action   = [
                            "codebuild:CreateReportGroup",
                            "codebuild:CreateReport",
                            "codebuild:UpdateReport",
                            "codebuild:BatchPutTestCases",
                            "codebuild:BatchPutCodeCoverages",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "*",
                        ]
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
}

