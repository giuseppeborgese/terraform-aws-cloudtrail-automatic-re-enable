resource "aws_cloudwatch_event_rule" "console" {
  name        = "${var.prefix}re-enable-cloudtrail"
  description = "Capture the CloudTrail events StopLogging and DeleteTrail and send to the lambda function"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.cloudtrail"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ],
    "eventName": [
      "StopLogging",
      "DeleteTrail"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = "${aws_cloudwatch_event_rule.console.name}"
  target_id = "${var.prefix}_re-enable-cloudtrail-lambda"
  arn       = "${aws_lambda_function.lambda.arn}"
}


resource "aws_iam_role" "lambda" {
  name = "${var.prefix}_re-enable-cloudtrail-send-notification"
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
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "mycloudwatch" {
    name        = "${var.prefix}-store-logs-push-notifications"
    role        = "${aws_iam_role.lambda.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "sns:Publish",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ssmfull" {
  role      = "${aws_iam_role.lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrailFullAccess"
}


variable "filename" { default = "re-enable-cloudtrail"}
resource "aws_lambda_function" "lambda" {
  filename           = "${path.module}/${var.filename}.py.zip"
  function_name      = "${var.prefix}-${var.filename}"
  role               = "${aws_iam_role.lambda.arn}"
  handler            = "${var.filename}.lambda_handler"
  source_code_hash   = "${filebase64sha256("${path.module}/${var.filename}.py.zip")}"
  runtime            = "python2.7"
  timeout            = 90
  description        = "This function called by CloudWatch Event re-enable CloudTrail if it is was disalbe and send a push notification"
  environment {
    variables = {
      SNS = "${var.sns}"
    }
  }
}


resource "aws_lambda_permission" "allow_secret_manager_call_Lambda" {
    function_name = "${aws_lambda_function.lambda.function_name}"
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    principal = "events.amazonaws.com"
}
