#!/bin/bash

BIN=`dirname $0`
[[ $# -eq 0 ]] && echo "Usage: $0 png1 png2 ..." && echo "eg: find . -iname \"*.png\" | xargs $0" && exit 1

for png in "$@"
do
    echo -n "$png	"
    pre_size=`stat -c"%s" "$png"`
    optipng_size=-1
    pngout_size=-1
    advdef_size=-1
    while :
    do
        [[ "`stat -c"%s" "$png"`" -eq "$optipng_size" ]] && break
        $BIN/optipng -o7 -q "$png"
        optipng_size="`stat -c"%s" "$png"`"

        [[ "`stat -c"%s" "$png"`" -eq "$pngout_size" ]] && break
        $BIN/pngout "$png" -q -y -knpTc,npLb
        pngout_size="`stat -c"%s" "$png"`"

        [[ "`stat -c"%s" "$png"`" -eq "$advdef_size" ]] && break
        $BIN/advdef -z4 "$png" >/dev/null
        advdef_size="`stat -c"%s" "$png"`"
    done
    $BIN/deflopt -sk "$png"
    $BIN/defluff < "$png" 2>/dev/null > ".$png.tmp.$$" && mv ".$png.tmp.$$" "$png"
    $BIN/deflopt -sk "$png"
    post_size=`stat -c"%s" $png`
    echo "$pre_size => $post_size"
done
