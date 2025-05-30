
import boto3
import datetime 

# setup dynamodb 
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users-dev')  

def handler(event, context):
    # access user attributes from event 
    user_attributes = event['request']['userAttributes']
    user_id = user_attributes['sub']
    email = user_attributes['email']
    username = event['userName'] # same as email for now 

    # create user record 
    user = {
        'userId': user_id,
        'email': email,
        'username': username, 
        'friends': [], 
        'createdAt': datetime.datetime.utcnow().isoformat()
    }

    table.put_item(Item=user)
    
    return event 
  
    
  