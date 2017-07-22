#!/bin/bash

url=$1
id=$(basename $url)

##echo \$url = $url
##echo \$id = $id

AUDIO_PATH="$HOME/Dropbox/Fortune\ Builders\ 2015/CorCo\ \-\ Capital\ Club\ Recordings"
AUDIO_PATH="$HOME/Dropbox/Fortune Builders 2015/CorCo - Capital Club Recordings"
AUDIO_PATH="$HOME/pcloud/CorCo - Capital Club Recordings"
AUDIO_PATH="$HOME/CorCo - Capital Club Recordings"

new="http://events.instantteleseminar.com/?eventid=$id"
new="http://events.iteleseminar.com/?eventid=$id"

function stuff1
{
   local tmp=$1

   if [[ $i =~ .EVENTVARS. ]]; then

      tmp=$(echo ${tmp:17})
      tmp=$(echo ${tmp:: -1})
      tmp="[$tmp]"

      date=$(echo ${tmp} | jq -r '.[] | .EventDate')
      fixme=$(echo $date | awk -F/ '{printf "%s/%s", $3, $1}')
      title=$(echo ${tmp} | jq -r '.[] | .Title')

   else
      tmp=$(echo ${tmp:19})
      tmp=$(echo ${tmp:: -2})
      tmp="[$tmp]"

      mp3=$(echo ${tmp} | jq -r '.[] | .RecordingURL')

   fi

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

##    if [[ $i =~ .Title. ]]; then
##        stuff $i
##    fi

##    if [[ $i =~ .EventDate. ]]; then
##        stuff $i
##    fi

##    if [[ $i =~ .mp3. ]]; then
##        stuff $i
##    fi

    if [[ $i =~ .EVENTVARS. ]]; then
        stuff1 $i
    fi

    if [[ $i =~ .REPLAYVARS. ]]; then
        stuff1 $i
    fi

done

echo "Getting Corco recording"

title=$(echo "$title" | sed -e 's|w/|with|g')
title=$(echo "$title" | sed -e 's|\&|and|g')
echo "Title = $title"
echo "Date  = $date"
echo "URL   = $mp3"
echo "Dir   = $fixme"

mypath="${AUDIO_PATH}/${fixme}"
myfile="${mypath}/${title}.mp3"
mytext="${mypath}/${title}.txt"

mkdir -pv "$mypath"

echo > $mytext
echo "Title: $title" | tee -a $mytext
echo "Date:  $date"  | tee -a $mytext
echo "URL:   $mp3"   | tee -a $mytext

#aria2c -x 8 -o "$myfile" $mp3
curl  $mp3 > $myfile

