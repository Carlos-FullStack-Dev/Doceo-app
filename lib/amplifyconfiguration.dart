const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "a8a8b9f7b72746ffb34a7ae3bb08bf04",
                    "region": "ap-northeast-1"
                },
                "pinpointTargeting": {
                    "region": "ap-northeast-1"
                }
            }
        }
    },
    "notifications": {
        "plugins": {
            "awsPinpointPushNotificationsPlugin": {
                "appId": "a8a8b9f7b72746ffb34a7ae3bb08bf04",
                "region": "ap-northeast-1"
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "AdminQueries": {
                    "endpointType": "REST",
                    "endpoint": "https://qoux659jta.execute-api.ap-northeast-1.amazonaws.com/dev",
                    "region": "ap-northeast-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                },
                "doceonew": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://walnk5bjtnbotmbokr5yziwt6q.appsync-api.ap-northeast-1.amazonaws.com/graphql",
                    "region": "ap-northeast-1",
                    "authorizationType": "AWS_IAM",
                    "apiKey": "da2-pzwv2syl3bewxpb3vqz4xscxj4"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "a8a8b9f7b72746ffb34a7ae3bb08bf04",
                        "Region": "ap-northeast-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "ap-northeast-1"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://walnk5bjtnbotmbokr5yziwt6q.appsync-api.ap-northeast-1.amazonaws.com/graphql",
                        "Region": "ap-northeast-1",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "doceonew_AWS_IAM"
                    },
                    "doceonew_API_KEY": {
                        "ApiUrl": "https://walnk5bjtnbotmbokr5yziwt6q.appsync-api.ap-northeast-1.amazonaws.com/graphql",
                        "Region": "ap-northeast-1",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-pzwv2syl3bewxpb3vqz4xscxj4",
                        "ClientDatabasePrefix": "doceonew_API_KEY"
                    },
                    "doceonew_AMAZON_COGNITO_USER_POOLS": {
                        "ApiUrl": "https://walnk5bjtnbotmbokr5yziwt6q.appsync-api.ap-northeast-1.amazonaws.com/graphql",
                        "Region": "ap-northeast-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "doceonew_AMAZON_COGNITO_USER_POOLS"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "ap-northeast-1:225f555f-f5ea-499d-b7fb-7c5c33d7d2e4",
                            "Region": "ap-northeast-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-northeast-1_sre9Ypoo1",
                        "AppClientId": "34rs9b1ja237vs2cr0k6l4r2d9",
                        "Region": "ap-northeast-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "doceonew-dev-dev.auth.ap-northeast-1.amazoncognito.com",
                            "AppClientId": "34rs9b1ja237vs2cr0k6l4r2d9",
                            "SignInRedirectURI": "myapp://,myapp://",
                            "SignOutRedirectURI": "myapp://",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "socialProviders": [
                            "GOOGLE",
                            "APPLE"
                        ],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "doceonewf04b1396d1b74f9da0b08869cadea72a222251-dev",
                        "Region": "ap-northeast-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "doceonewf04b1396d1b74f9da0b08869cadea72a222251-dev",
                "region": "ap-northeast-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';
