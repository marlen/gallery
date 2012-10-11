#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'

#$SIZES = [80 , 100 , 110 , 128]

$SIZES = [0.1, 0.05, 0.03, 0.02]
$SIZES2 = [ 100]
$THUMBS_PATH = 'thumbs'
$MED_SIZE_PATH = 'med_size'

image = Magick::Image.read(ARGV[0]).first

file = "#{$THUMBS_PATH}/#{ARGV[0]}"
puts "Generating image : #{file}"
out = image.crop_resized(75,75, Magick::NorthGravity)
out.write(file)

file = "#{$MED_SIZE_PATH}/#{ARGV[0]}"
puts "Generating image : #{file}"
out = image.resize_to_fit(500,340)

if (image.orientation == Magick::LeftBottomOrientation )
    out = out.rotate( 270 )
#out = EXIFR::JPEG.new(file).orientation.transform_rmagick(out)
    print "TRUE\n"
end

out.write( file )
