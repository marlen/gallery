#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'


$thumbs_path = 'thumbs'

image = Magick::Image.read(ARGV[0]).first
if ( EXIFR::JPEG.new(ARGV[0]).orientation == EXIFR::TIFF::LeftBottomOrientation ) 
   image = EXIFR::JPEG.new(ARGV[0]).orientation.transform_rmagick(image)
   image.write("correct2.JPG")
   print "TRUE\n"
end 

