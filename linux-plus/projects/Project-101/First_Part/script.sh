#!/bin/bash

cat $FILE | grep serdar | grep Terminate | grep -Eo "i-[a-zA-Z0-9]{17}" | sort | uniq > /tmp/result.txt 
echo "Your result is ready under the /tmp/result.txt file"