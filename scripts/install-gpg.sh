#!/bin/bash
KEYFILE="openflighthpc.private.pgp"
S3_PATH="openflighthpc-private"

echo "Downloading secret key"
aws s3 cp s3://$S3_PATH/$KEYFILE ~/$KEYFILE

echo "Installing GPG key for OpenFlightHPC"
read -p "This will prompt for the private key's password, continue? (y/n) " answer
if [[ "$answer" =~ (y|yes|Y|Yes|YES) ]] ; then
    echo "continuing..."
else
    echo "Key import denied, exiting..."
    exit 1
fi

gpg --import ~/$KEYFILE

echo "Removing local GPG key"
rm -f ~/$KEYFILE
