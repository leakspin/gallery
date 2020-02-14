#!/bin/bash

FOLDER="images/raw/"

for a in $(find $FOLDER -type f)
do
    echo "$a"

    filename=$(basename -- "$a")
    extension="${filename##*.}"
    subfolder=$(dirname -- "$a" | sed "s#$FOLDER##")

    if [ ! -d "images/thumbs/$subfolder" ]
    then
        mkdir "images/thumbs/$subfolder"
    fi

    if [ ! -f "images/thumbs/$subfolder/$filename" ]
    then
        ffmpeg -i "$a" -vf scale=500:-1 images/thumbs/$subfolder/"$filename"
    fi

    if [ ! -d "images/web/$subfolder" ]
    then
        mkdir "images/web/$subfolder"
    fi

    if [ ! -f "images/web/$subfolder/$filename" ]
    then
        ffmpeg -i "$a" -vf scale=1920:-1 images/"$filename"
        
        if [[ $extension == 'jpg' ]]
        then
            jpegtran -optimize -copy none -perfect -v images/"$filename" > images/web/$subfolder/"$filename"
        elif [[ $extension == 'png' ]]
        then
            optipng -out images/web/$subfolder/"$filename" images/"$filename"
        else
            cp images/"$filename" images/web/$subfolder/"$filename"
        fi

        rm images/"$filename"
    fi
done