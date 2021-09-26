# terraform-module-lambda-aws

This Terraform module provisions a Lambda function on AWS configuring a Kinesis Data Stream input trigger.

## Usage

```
terraform {
  backend "s3" {
    bucket = "bucket-name"
    key    = "bucket-file"
    region = "us-east-2"
  }
}

module "lambda_function" {
  source               = "github.com/PhilRanzato/terraform-module-lambda-aws"

  region               = "us-east-2"

  lambda_function_name = "my-lambda"
  lambda_description   = "Triggered by Kinesis"
  lambda_handler       = "lambda.lambda_handler"
  lambda_runtime       = "python3.8"
  lambda_source_path   = "function.zip"

  kinesis_stream       = "my-kinesis-data-stream"

}
```

## Input Variables

```yaml
region: string # AWS region to use
access_key: string # AWS Access Key ID
secret_key: string # AWS Secret Access Key
lambda_function_name: string # Lambda function name
lambda_description: string # Lambda function description
lambda_handler: string # Lambda function handler (format: filename.handler_function)
lambda_runtime: string # Lambda function runtime
lambda_source_path: string # Path of the Lambda function archive
kinesis_stream: string # Kinesis data stream name to use as trigger
```

## Output Variables

```
```
