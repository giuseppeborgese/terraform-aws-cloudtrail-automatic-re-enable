import json
import boto3
import sys
import os

SNS = os.environ['SNS']


def lambda_handler(event, context):
    client = boto3.client('cloudtrail')
    if event['detail']['eventName'] == 'StopLogging' or event['detail']['eventName'] == 'DeleteTrail':
        subject=''
        if event['detail']['eventName'] == 'StopLogging':
            response = client.start_logging(Name=event['detail']['requestParameters']['name'])
            subject = 'A CloudTrail StopLogging action was triggered'
            message = subject + '\n' # you can't have line break in the subject
            message = message + 'The Security System has immediately re-enabled CloudTrail' + '\n\n\n'
        else:
            subject = 'A CloudTrail DeleteTrail action was triggered'
            message = subject + '\n' # you can't have line break in the subject

        message = message + 'for the account with id: ' + event['account'] + '\n'
        message = message + 'The event was triggered at this UTC time: '+ event['detail']['eventTime'] + '\n'
        message = message + 'The CloudTrail interested was: ' + event['detail']['requestParameters']['name'] + '\n'
        message = message + 'The user that perform the action was: ' + event['detail']['userIdentity']['arn'] + '\n'
        message = message + 'From the Source IP Address: ' + event['detail']['sourceIPAddress'] + '\n\n\n'
        message = message + 'If you want to read the full event is here:' + '\n' + str(event)
        print(message)

        sns_client = boto3.client('sns')
        sns_client.publish(TopicArn=SNS,Message=message,Subject=subject+' for '+event['account'])
