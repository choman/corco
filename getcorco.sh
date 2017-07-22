#!/bin/bash

url=$1
id=$(basename $url)

echo \$url = $url
echo \$id = $id


AUDIO_PATH="$HOME/Dropbox/Fortune\ Builders\ 2015/CorCo\ \-\ Capital\ Club\ Recordings"
AUDIO_PATH="$HOME/Dropbox/Fortune Builders 2015/CorCo - Capital Club Recordings"
AUDIO_PATH="$HOME/pcloud/CorCo - Capital Club Recordings"
AUDIO_PATH="$HOME/CorCo - Capital Club Recordings"

new="http://events.instantteleseminar.com/?eventid=$id"
new="http://events.iteleseminar.com/?eventid=$id"

function stuff1
{
   local tmp=$1

   echo ${tmp}
   tmp=$(echo ${tmp:17})
   tmp=$(echo ${tmp:: -1})
   tmp="[$tmp]"

   echo $(echo $tmp | jq .)
   echo $(echo $tmp | jq '.[].id')
   echo $(echo $tmp | jq '.[]|keys|.[0]')
   echo ${tmp} | jq '.EventDate | to_entries[]'
   echo ${tmp} | jq '.Title | to_entries[]'
   echo ${tmp} | jq '[.Title]'

   echo $(echo $tmp | jq '.[] | select(.id=="EventDate")')
   echo $(echo $tmp | jq '.[] | select(.id=="Title")')

}

function stuff
{
    local tmp=$1
    local line=""

    for line in $(echo $tmp | tr ',' '\n'); do
        if [[ $line =~ .Title\". ]]; then
            title=$(echo ${line#*:} | tr -d '\\' | tr -d '"')
            echo $title
        fi

        if [[ $line =~ .EventDate\". ]]; then
            date=$(echo ${line#*:} | tr -d '\\' | tr -d '"')
            fixme=$(echo $date | awk -F/ '{printf "%s/%s", $3, $1}')
        fi

        if [[ $line =~ .RecordingURL\". ]]; then
            url=$(echo ${line#*:} | tr -d '\\' | tr -d '"')
            mp3=$(echo ${url:: -3})
        fi

    done
}

IFS="
"


for i in $(curl -s $new | egrep ':title|EventDate|mp3')
do
    if [[ $i =~ .Title. ]]; then
        stuff1 $i
        stuff $i
    fi

    if [[ $i =~ .EventDate. ]]; then
        stuff $i
    fi

    if [[ $i =~ .mp3. ]]; then
        stuff $i
    fi

done

echo "hi"

title=$(echo "$title" | sed -e 's|w/|with|g')
title=$(echo "$title" | sed -e 's|\&|and|g')
echo $title
echo $date
echo $mp3
echo $fixme

mypath="${AUDIO_PATH}/${fixme}"
myfile="${mypath}/${title}.mp3"
mytext="${mypath}/${title}.txt"

exit

mkdir -pv "$mypath"

echo > $mytext
echo "Title: $title" | tee -a $mytext
echo "Date:  $date"  | tee -a $mytext
echo "URL:   $mp3"   | tee -a $mytext

#aria2c -x 8 -o "$myfile" $mp3
curl  $mp3 > $myfile

