provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.layer_name
  compatible_runtimes = ["python3.8", "python3.9", "python3.10", "python3.12"]
  filename            = "../lambda_layer.zip"
}

output "layer_arn" {
  value = aws_lambda_layer_version.lambda_layer.arn
}
