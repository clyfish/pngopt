#!/bin/bash

BIN=`dirname $0`
[[ $# -eq 0 ]] && echo "Usage: $0 jpg1 jpg2 ..." && echo "eg: find . -iname \"*.jpg\" | xargs $0" && exit 1

for jpg in "$@"
do
    echo -n "$jpg	"
    pre_size=`stat -c"%s" $jpg`
    $BIN/jpegoptim --strip-com --strip-exif --strip-iptc "$jpg" >/dev/null
    post_size=`stat -c"%s" $jpg`
    echo "$pre_size => $post_size"
done
