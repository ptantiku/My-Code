#!/bin/bash
# This file for download slides from slideshare.com and convert to pdf
# author: ptantiku

if [ -z "$1" ]
then
    echo "Usage: $0 slideshare_url"
    echo "Ex: $0 http://www.slideshare.net/lostinsecurity/ftpsqlcache-injections"
    exit 1
fi

mkdir /tmp/slideshare
cd /tmp/slideshare
curl "$1" | grep -Eoi 'http://image.slidesharecdn.com/[^"]*1024.jpg\?cb=[0-9]+' | wget -i -
for i in *; do j=$(echo $i|sed -r 's/.*-([0-9]+)-.*/\1.jpg/'); mv $i $j; done
convert `ls -1 | sort -n` out.pdf
