#!/bin/bash
# $1 - Source path
WORKING_BASE_PATH="/Users/elena/Sites"
GALLERIES_DIR="galleries"
MED_SIZED_DIR="med_size"
THUMBS_DIR="thumbs"
RESIZE_IMAGES_PROGRAM=/Users/elena/Documents/workspace/gallery_scripts/pics.rb
CREATE_XML_PROGRAM=/Users/elena/Documents/workspace/gallery_scripts/makexml.rb

if [ $# -lt 1 ]
then
    echo "Usage: $0 <source images dirpath>"
    exit 1
fi

if [ ! -d $1 ]
then
    echo "ERROR: $1 is not a directory and could not be found!"
    exit 1
fi

dir_name=`basename $1`
echo "cp -r  $1 $WORKING_BASE_PATH/$GALLERIES_DIR/"
cp -r  $1 $WORKING_BASE_PATH/$GALLERIES_DIR/
chmod -R u+w $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name

echo "$RESIZE_IMAGES_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name"
$RESIZE_IMAGES_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name

echo "$CREATE_XML_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/$MED_SIZED_DIR"
$CREATE_XML_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/$MED_SIZED_DIR

echo "rm -f $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/*.JPG"
rm -f $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/*.JPG

echo "$WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/" >> $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt
