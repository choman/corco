#!/bin/bash

url=$1
id=$(basename $url)

AUDIO_PATH="$HOME/Dropbox/Fortune\ Builders\ 2015/CorCo\ \-\ Capital\ Club\ Recordings"
AUDIO_PATH="$HOME/Dropbox/Fortune Builders 2015/CorCo - Capital Club Recordings"

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
        tmp=`echo $i | awk '{print $4}' | sed -e "s/'//"`
        date=$(echo $tmp | awk -F/ '{printf("%s/%s", $3, $1)}')
        echo "\$date = ($date)"
    fi

    if [ -z "${i##*mp3*}" ] ;then
        mp3=`echo $i |  grep -o 'href=['"'"'"][^"'"'"']*['"'"'"]' | \
                   sed -e 's/href=["'"'"']//' -e 's/["'"'"']$//'`
        echo "mp3 = ($mp3)"
    fi

done

echo "hi"

mypath="${AUDIO_PATH}/${date}"
myfile="${mypath}/${title}.mp3"
mytext="${mypath}/${title}.txt"

mkdir -pv "$mypath"

echo "Title: $title" >  $mytext
echo "Desc:  $desc"  >> $mytext
echo "URL:   $mp3"   >> $mytext

#aria2c -x 8 -o "$myfile" $mp3
curl $mp3 > $myfile

