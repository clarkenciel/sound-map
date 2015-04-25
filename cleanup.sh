#!/bin/bash
DIR="`pwd`"

[ -f $DIR/index.txt ] && rm $DIR/index.txt

for FILE in $DIR/snds/*.wav; do
    [ -f $FILE ] && rm $FILE
done

for FILE in $DIR/orbs/*.orb; do
    [ -f $FILE ] && rm $FILE
done
