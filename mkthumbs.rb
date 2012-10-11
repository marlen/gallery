#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'

#$SIZES = [80 , 100 , 110 , 128]

$SIZES = [0.1, 0.05, 0.03, 0.02]
$SIZES2 = [ 100]
$thumbs_path = 'thumbs'

image = Magick::Image.read(ARGV[0]).first
if ( EXIFR::JPEG.new(ARGV[0]).orientation == EXIFR::TIFF::LeftBottomOrientation ) 
   image = EXIFR::JPEG.new(ARGV[0]).orientation.transform_rmagick(image)
   print "TRUE\n"
end 
$SIZES.each do |sz|
  puts "Generating image : #{sz}"
  out = image.resize(sz)
  file = "out_#{sz}#{ARGV[0]}"
  out.write(file)
end

  puts "Generating image : #{$thumbs_path}/out_#{ARGV[0]}"
  out = image.crop_resized(75,75, Magick::CenterGravity)
  file = "#{$thumbs_path}/out_#{ARGV[0]}"
  out.write(file)


