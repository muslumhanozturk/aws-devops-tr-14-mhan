#!/bin/bash
for x in {1..200}
do
        output=$(curl -s http://mhan-WAF-lb-446010843.us-east-1.elb.amazonaws.com/ | grep h1)     
        echo $x - $output
        sleep 0.5
done
