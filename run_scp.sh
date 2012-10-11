#!/bin/bash
# $1 - Source path
WORKING_BASE_PATH="/Users/elena/Sites"
GALLERIES_DIR="galleries"
MED_SIZED_DIR="med_size"
THUMBS_DIR="thumbs"
RESIZE_IMAGES_PROGRAM=/Users/elena/Documents/workspace/gallery_scripts/pics.rb
CREATE_XML_PROGRAM=/Users/elena/Documents/workspace/gallery_scripts/makexml.rb
DEST_PATH=iteahaus@iteaha.us:001haoandelena/public/galleries/

if [ $# -lt 1 ]
then
    echo "Usage: $0 <source images dirpath>"
    exit 1
fi

#if [ ! -d $1 ]
#then
#    echo "ERROR: $1 is not a directory and could not be found!"
#    exit 1
#fi

#dir_name=`basename $1`
#echo "cp -r  $1 $WORKING_BASE_PATH/$GALLERIES_DIR/"
#cp -r  $1 $WORKING_BASE_PATH/$GALLERIES_DIR/
#chmod -R u+w $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name

#echo "$RESIZE_IMAGES_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name"
#$RESIZE_IMAGES_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name

#echo "$CREATE_XML_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/$MED_SIZED_DIR"
#$CREATE_XML_PROGRAM $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/$MED_SIZED_DIR

#echo "rm -f $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/*.JPG"
#rm -f $WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name/*.JPG

#echo "$WORKING_BASE_PATH/$GALLERIES_DIR/gallery.xml" >> $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt
#echo "$WORKING_BASE_PATH/$GALLERIES_DIR/$dir_name" >> $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt

#Removes duplicate sourcepaths
sort -u -o $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt

#Upload each line from toupload.txt list
while read sourcepath 
do
   echo "scp -r $sourcepath $DEST_PATH"
   scp -r $sourcepath $DEST_PATH
   ret_code=$?
   if [ "$ret_code" -ne "0" ]; then
      echo "ERROR: scp -r $sourcepath $DEST_PATH"
      exit $ret_code 
   fi
done < $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt 

#Back up galleries.xml before uploading the new one
echo "scp ${DEST_PATH}galleries.xml ${DEST_PATH}galleries.xml.bak "
scp ${DEST_PATH}galleries.xml ${DEST_PATH}galleries.xml.bak
ret_code=$?
if [ "$ret_code" -ne "0" ]; then
   echo "ERROR: scp ${DEST_PATH}galleries.xml ${DEST_PATH}galleries.xml.bak"
   exit $ret_code
fi

#Upload the new gallaries.xml
echo "scp $WORKING_BASE_PATH/$GALLERIES_DIR/galleries.xml ${DEST_PATH}"
scp $WORKING_BASE_PATH/$GALLERIES_DIR/galleries.xml ${DEST_PATH}
ret_code=$?
if [ "$ret_code" -ne "0" ]; then
   echo "ERROR: scp $WORKING_BASE_PATH/$GALLERIES_DIR/galleries.xml ${DEST_PATH}"
   exit $ret_code
fi

#Rename  toupload.txt as uploaded.txt 
echo "mv $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt $WORKING_BASE_PATH/$GALLERIES_DIR/uploaded.txt"
mv $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt $WORKING_BASE_PATH/$GALLERIES_DIR/uploaded.txt
ret_code=$?
if [ "$ret_code" -ne "0" ]; then
   echo "ERROR: mv $WORKING_BASE_PATH/$GALLERIES_DIR/toupload.txt $WORKING_BASE_PATH/$GALLERIES_DIR/uploaded.txt"
   exit $ret_code
fi

exit 0
