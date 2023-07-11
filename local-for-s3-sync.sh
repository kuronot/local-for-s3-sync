#!/bin/bash
#How to use: bash local-for-s3-sync.sh ${aws-vault-profile name} ${S3 name} ${dir name of environment to update} ${dir name to update}

#Argument check
if [ $# != 4 ]; then
    echo "Argument error: usage bash $0 aws-vault-profile name Target S3 name Directory name"
    exit 1
fi

#Argument receipt
ROLE=$1
S3_NAME=$2
DIR_PREFIX=$3
DIR_NAME=$4

#Set up a aws-vault-profile.
export SWICHROLE=$ROLE
echo $SWICHROLE

shopt -s expand_aliases
alias av='aws-vault exec $SWICHROLE --no-session --'

echo "processing start"

#Git Pull to keep code up-to-date
git pull

#Reflect modernized json to S3
av aws s3 sync ../catalog/${DIR_PREFIX}/${DIR_NAME}/ s3://${S3_NAME}/${DIR_NAME} --exact-timestamps


echo "end of process"
