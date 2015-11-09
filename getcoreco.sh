#!/bin/bash

url=$1
id=`basename $url`

##new="http://events.instantteleseminar.com/?eventid=$id"

IFS="
"

for i in `curl -s curl -s http://events.attendthisevent.com/Classic/?eventid=$id | egrep ':title|:description|TargetDate|mp3'`
do
     echo $i
done

