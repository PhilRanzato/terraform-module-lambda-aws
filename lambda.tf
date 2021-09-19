resource "aws_iam_role" "iam_for_lambda" {
  name = "terraform-iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dynamodb.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "kinesis.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "link_policy_kinesis" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.kinesis_full_access.arn
}

resource "aws_iam_role_policy_attachment" "link_policy_dynamo" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.dynamo_full_access.arn
}

resource "aws_lambda_function" "process_kinesis_stream" {
  filename      = "${var.lambda_source_path}"
  function_name = "${var.lambda_function_name}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "${var.lambda_handler}"
  description = "${var.lambda_description}"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("${var.lambda_source_path}")

  runtime = "${var.lambda_runtime}"

}

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn  = data.aws_kinesis_stream.stream.arn
  function_name     = aws_lambda_function.process_kinesis_stream.arn
  starting_position = "LATEST"
}
