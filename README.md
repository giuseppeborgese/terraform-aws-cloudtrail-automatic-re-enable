# Terraform AWS Cloudtrail Automatic Re-enable
Automatic re-enable of CloudTrail in case of malicious or accidentally disable. 
This is a security enforce module for CloudTrail.

## Purpose 
The project catches 2 events one is the StopLogging the other is DeleteTrail.
* StopLogging cause the CloudTrail enabling again and sends an email to the SNS topic.
* DeleteTrail sends an email to the SNS topic.

## Schema
The Terraform module creates the components in the red square.
![schema](https://raw.githubusercontent.com/giuseppeborgese/terraform-aws-cloudtrail-automatic-re-enable/master/img/schema.png)


## Prerequisites:
These 2 elements 
CloudTrail should be already created or created after.
SNS with Email confirmation 

## Creation
Use this code in your terraform project 

``` hcl

module "sec" {
   source = "giuseppeborgese/cloudtrail-automatic-re-enable/aws"
   prefix = "ts"
   sns    = "arn:aws:sns:us-east-1:01234567:giuseppe-sns"
}
```


## In Action Youtube Video


## Feedback
if you like this module leave a comment or a thumbs up in the youtube video, subscribe to my youtube channel and follow my article on medium https://medium.com/@giuseppeborgese 