#!/bin/bash

CREDS=$(aws sts assume-role --role-arn arn:aws:iam::180217099948:role/atlantis-access --role-session-name local-test)

export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r ".Credentials.SessionToken")

docker-compose up --build -d

