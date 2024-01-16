#!/bin/sh
if [ -n "$AWS_SECRET_ID" ]
then
    aws secretsmanager get-secret-value --secret-id ${AWS_SECRET_ID} --query SecretString --output text | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' | sed 's/[\&"'\''()$<>|;`]/\\&/g' > /tmp/secrets.env
    eval $(cat /tmp/secrets.env | sed 's/^/export /')
    rm -f /tmp/secrets.env
fi

sql-migrate $@