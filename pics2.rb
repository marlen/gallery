#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'

class Picture 

   def initialize (input_filename)
      @image = Magick::Image.read(input_filename).first
      @input_filename = input_filename
   end 
   
   def thumb_size 

      $THUMBS_PATH = 'thumbs'

      dir_name=File.dirname(@input_filename)      
      gif_name=File.basename(@input_filename)
      gif_name=gif_name.sub('.JPG','.GIF')
      file = "#{dir_name}/#{$THUMBS_PATH}/#{gif_name}"
      puts "Generating image : #{file}"
      out = @image.crop_resized(75,75, Magick::NorthGravity)
      if (@image.orientation == Magick::LeftBottomOrientation )
         out = out.rotate(270)
      end
      thumbs_path = "#{dir_name}/#{$THUMBS_PATH}"
      unless (File.exist?(thumbs_path))
        Dir.mkdir(thumbs_path)
      end
      out.write(file)
   end

   def med_size 
   
      $MED_SIZE_PATH = 'med_size'
 
      dir_name=File.dirname(@input_filename)      
      base_name=File.basename(@input_filename)
      file = "#{dir_name}/#{$MED_SIZE_PATH}/#{base_name}"
      puts "Generating image : #{file}"
      out = @image.resize_to_fit(500,340)

      if (@image.orientation == Magick::LeftBottomOrientation )
         out = out.rotate(270)
         print "TRUE\n"
      end

      med_size_path = "#{dir_name}/#{$MED_SIZE_PATH}"
      unless (File.exist?(med_size_path))
        Dir.mkdir(med_size_path)
      end
      out.write(file) { 
#         self.quality = 50
         if (@image.orientation == Magick::LeftBottomOrientation ) 
             self.orientation = Magick::TopLeftOrientation
         end 
      }
   end
   
  
end

$MED_SIZE_PATH = 'med_size'
  
Dir.glob("#{ARGV[0]}/*.JPG")  {
   |x| pic = Picture.new(x)
       pic.thumb_size
       pic.med_size
       GC.start  }

