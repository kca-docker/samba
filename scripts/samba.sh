#!/usr/bin/env bash
set -o nounset 


# Verify smb.conf
testparm -s

if [ $? -eq 0 ] 
then
    smbd -D
else
    testparm -s > /var/log/samba/testparm.log
fi