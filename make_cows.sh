#!/bin/sh

#
# Transform image files pixel per pixel into cow files.
#

for fullfilename in ./scrapped-data/*.png
do
    filename=$(basename "$fullfilename")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo "Now making $filename into a cow."
    ruby cow.rb "$fullfilename" > "cows/$filename.cow"
done
