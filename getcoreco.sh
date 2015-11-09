#!/bin/bash

url=$1
id=`basename $url`

##new="http://events.instantteleseminar.com/?eventid=$id"

IFS="
"

for i in `curl -s curl -s http://events.attendthisevent.com/Classic/?eventid=$id | egrep ':title|:description|TargetDate|mp3'`
do
    if [ -z "${i##*title*}" ] ;then
        echo "String '$i' contain substring: '$reqsubstr'."
    fi

    if [ -z "${i##*description*}" ] ;then
        echo "String '$i' contain substring: '$reqsubstr'."
    fi

    if [ -z "${i##*TargetDate*}" ] ;then
        echo "String '$i' contain substring: '$reqsubstr'."
    fi

    if [ -z "${i##*mp3*}" ] ;then
        mp3=`echo $i |  grep -o ' href=['"'"'"][^"'"'"']*['"'"'"]' | \
                   sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`
        echo $mp3
    fi

done

