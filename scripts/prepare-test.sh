#!/bin/bash
yum install -y epel-release
yum install -y -e0 https://openflighthpc.s3-eu-west-1.amazonaws.com/repos/openflight/x86_64/openflighthpc-release-1-1.noarch.rpm
yum makecache
