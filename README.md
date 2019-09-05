# Terraform AWS Cloudtrail Automatic Re-enable
Automatic re-enable of CloudTrail in case of malicious or accidentally disable. 

This is a security enforce module for CloudTrail.

## Why you need this

If somebody hacks your AWS account the first action would be disabled or delete the CloudTrail to cover his tracks. Receive an alert, in this case, can save our business from huge and expensive disasters.

## Purpose 
The project catches 2 events one is the StopLogging the other is DeleteTrail.
* StopLogging cause the CloudTrail enabling again and sends an email to the SNS topic.
* DeleteTrail sends an email to the SNS topic.

## Schema
The Terraform module creates the components in the red square.
![schema](https://raw.githubusercontent.com/giuseppeborgese/terraform-aws-cloudtrail-automatic-re-enable/master/img/schema.png)


## Prerequisites:
These 2 elements should be already created.  
* CloudTrail
* SNS with Email confirmation 

## Creation
Use this code in your terraform project 

``` hcl

module "cloudtrail-automatic-re-enable" {
   source = "giuseppeborgese/cloudtrail-automatic-re-enable/aws"
   prefix = "ts"
   sns    = "arn:aws:sns:us-east-1:01234567:giuseppe-sns"
}
```


## In Action Youtube Video

[![AWS Cloudtrail Automatic Re-enable with a Terraform Module](https://img.youtube.com/vi/9HYimiCOLD0/0.jpg)](https://youtu.be/9HYimiCOLD0)


## Feedback
if you like this module leave a comment or a thumbs up in the youtube video, subscribe to my youtube channel https://www.youtube.com/channel/UC-NS9CMNufWQglUyVQzaFqQ and follow my article on medium https://medium.com/@giuseppeborgese 

## References
If you want to know more about Security in AWS take a look to this course https://linuxacademy.com/course/aws-certified-security-specialty/ 
