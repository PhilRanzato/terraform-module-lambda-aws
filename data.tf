data "aws_kinesis_stream" "stream" {
  name = "${var.kinesis_stream}"
}

data "aws_iam_policy" "dynamo_full_access" {
  name = "AmazonDynamoDBFullAccess"
}

data "aws_iam_policy" "kinesis_full_access" {
  name = "AmazonKinesisFullAccess"
}
