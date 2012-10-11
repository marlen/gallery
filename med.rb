#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'

#$SIZES = [80 , 100 , 110 , 128]

$THUMBS_PATH = 'thumbs'
$MED_SIZE_PATH = 'med_size'

image = Magick::Image.read(ARGV[0]).first

gif_name=ARGV[0].sub('.JPG','.GIF')
file = "#{$THUMBS_PATH}/#{gif_name}"
puts "Generating image : #{file}"
out = image.crop_resized(75,75, Magick::NorthGravity)
if (image.orientation == Magick::LeftBottomOrientation )
    out = out.rotate(270)
end
out.write(file)
#
# CREATING MEDIUM SIZED IMAGE
#
file = "#{$MED_SIZE_PATH}/#{ARGV[0]}"
puts "Generating image : #{file}"
out = image.resize_to_fit(500,340)

if (image.orientation == Magick::LeftBottomOrientation )
    out = out.rotate(270)
#out = EXIFR::JPEG.new(file).orientation.transform_rmagick(out)
    print "TRUE\n"
end

out.write(file) { 
#Image::Info.orientation =  Magick::TopLeftOrientation 
   self.quality = 50
   if (image.orientation == Magick::LeftBottomOrientation ) 
       self.orientation = Magick::TopLeftOrientation
   end 
}


