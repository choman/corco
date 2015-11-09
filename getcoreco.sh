#!/bin/bash

url=$1
id=`basename $url`

##new="http://events.instantteleseminar.com/?eventid=$id"

IFS="
"

for i in `curl -s curl -s http://events.attendthisevent.com/Classic/?eventid=$id | egrep ':title|:description|TargetDate|mp3'`
do
    if [ -z "${i##*title*}" ] ;then
        title=`echo $i | grep -o ' content=['"'"'"][^"'"'"']*['"'"'"]' | \
                         sed -e 's/^ content=["'"'"']//' -e 's/["'"'"']$//'`
        echo "title = ($title)"
    fi

    if [ -z "${i##*description*}" ] ;then
        desc=`echo $i | grep -o ' content=['"'"'"][^"'"'"']*['"'"'"]' | \
                         sed -e 's/^ content=["'"'"']//' -e 's/["'"'"']$//'`
        echo "desc = ($desc)"
    fi

    if [ -z "${i##*TargetDate*}" ] ;then
        echo $i | awk '{print $4}' | sed -e "s/'//"
    fi

    if [ -z "${i##*mp3*}" ] ;then
        mp3=`echo $i |  grep -o 'href=['"'"'"][^"'"'"']*['"'"'"]' | \
                   sed -e 's/href=["'"'"']//' -e 's/["'"'"']$//'`
        echo "mp3 = ($mp3)"
    fi

done

