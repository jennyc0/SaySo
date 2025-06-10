
import boto3
import datetime 

# setup dynamodb 
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users-dev')  

def handler(event, context):
    # access user attributes from event 
    user_attributes = event['request']['userAttributes']
    user_id = user_attributes['sub']
    username = user_attributes.get('custom:username', user_attributes.get('userName')) # default username as email 
    email = user_attributes['email']
    # username = event['userName'] # same as email for now 

    # create user record 
    user = {
        'userId': user_id,
        'email': email,
        'username': username, 
        'friends': [], 
        'createdAt': datetime.datetime.utcnow().isoformat(),
        'friendRequestsSent': [],
        'friendRequestsReceived': []
    }

    table.put_item(Item=user)
    
    return event
