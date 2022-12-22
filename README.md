# swift-keyspaces

An experiment connecting Swift to AWS Keyspaces (Cassandra)

- [CassandraClient](https://github.com/apple/swift-cassandra-client)
- [AWSLambdaRuntime](https://github.com/swift-server/swift-aws-lambda-runtime)
- [AWS Lambda](https://aws.amazon.com/lambda/)
- [AWS Keyspaces](https://aws.amazon.com/keyspaces/)

## AWS Configuration

This project includes a CloudFormation template that gets you nearly set up. You also need a user with Keyspaces credentials and an S3 bucket to host all of the artifacts.

Policy needed for user:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cassandra:Create",
                "cassandra:Select",
                "cassandra:Modify"
            ],
            "Resource": [
                "arn:aws:cassandra:*:YOUR_ACCOUNT_ID_GOES_HERE:/keyspace/swift_keyspaces_test/",
                "arn:aws:cassandra:*:YOUR_ACCOUNT_ID_GOES_HERE:/keyspace/swift_keyspaces_test/table/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "cassandra:Select",
            "Resource": "arn:aws:cassandra:*:YOUR_ACCOUNT_ID_GOES_HERE:/keyspace/system/table/*"
        }
    ]
}
```
