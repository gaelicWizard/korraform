resource "aws_kms_key" "codebuild" {
    description              = "Default master key that protects my S3 objects when no other key is defined"
    enable_key_rotation      = true
    policy                   = jsonencode(
        {
            Id        = "auto-s3"
            Statement = [
                {
                    Action    = [
                        "kms:Encrypt",
                        "kms:Decrypt",
                        "kms:ReEncrypt*",
                        "kms:GenerateDataKey*",
                        "kms:DescribeKey",
                    ]
                    Condition = {
                        StringEquals = {
                            "kms:CallerAccount" = ["${data.aws_caller_identity.default.account_id}"]
                            "kms:ViaService"    = "s3.us-east-1.amazonaws.com"
                        }
                    }
                    Effect    = "Allow"
                    Principal = {
                        AWS = "*"
                    }
                    Resource  = "*"
                    Sid       = "Allow access through S3 for all principals in the account that are authorized to use S3"
                },
                {
                    Action    = [
                        "kms:*",
                    ]
                    Effect    = "Allow"
                    Principal = {
                        AWS = ["arn:aws:iam::${data.aws_caller_identity.default.account_id}:root"]
                    }
                    Resource  = "*"
                    Sid       = "Allow direct access to key metadata to the account"
                },
            ]
            Version   = "2012-10-17"
        }
    )
}

resource "aws_kms_alias" "codebuild" {
    name           = "alias/key"
    target_key_id  = aws_kms_key.codebuild.key_id
}
