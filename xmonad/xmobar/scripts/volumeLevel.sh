#!/bin/bash

MASTER=$( amixer get Master )
VOLUME=$( echo "$MASTER" | grep -Po "\d+%" | head -1 )
COLORFG="#c099ff"
COLORBG="#2f334d"
[[ $MASTER == *"[off]"* ]] && COLORFG="#545c7e"
echo "<fc=$COLORFG,$COLORBG>$VOLUME</fc>"

# OLD SCRIPT<[[[
# str=$(amixer sget Master,0)
# str1=${str#Simple*[}
# v1=${str1%%]*]}
# il=$(expr index "$str1" [)
# o="off"
# mutel=''

# if [ "${str1:$il:3}" == $o ];
# then
#     mutel='M';
# fi

# str2=${str1#"${str1:0:1}"*[}
#     str1=$str2
#     str2=${str1#"${str1:0:1}"*[}
# muter=''

# if [ "${str2:0:3}" = $o ];
# then
#     muter='[M]';
# fi

# v=${v1}\ $muter

# echo "$v"
# ]]]>
