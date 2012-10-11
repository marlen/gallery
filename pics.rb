#!/opt/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'exifr'

class Picture 

   def thumb_size (input_filename)

      $THUMBS_PATH = 'thumbs'
 
      image = Magick::Image.read(input_filename).first

      dir_name=File.dirname(input_filename)      
      gif_name=File.basename(input_filename)
      gif_name=gif_name.sub('.JPG','.GIF')
      file = "#{dir_name}/#{$THUMBS_PATH}/#{gif_name}"
      puts "Generating image : #{file}"
      out = image.crop_resized(75,75, Magick::NorthGravity)
      if (image.orientation == Magick::LeftBottomOrientation )
         out = out.rotate(270)
      end
      if (image.orientation == Magick::RightTopOrientation )
         out = out.rotate(90)
      end
      if (image.orientation == Magick::BottomRightOrientation )
         out = out.rotate(180)
      end
      thumbs_path = "#{dir_name}/#{$THUMBS_PATH}"
      unless (File.exist?(thumbs_path))
        Dir.mkdir(thumbs_path)
      end
      out.write(file)
   end

   def med_size (input_filename)

      $MED_SIZE_PATH = 'med_size'
 
      image = Magick::Image.read(input_filename).first

      dir_name=File.dirname(input_filename)      
      base_name=File.basename(input_filename)
      file = "#{dir_name}/#{$MED_SIZE_PATH}/#{base_name}"
      puts "Generating image : #{file}"
      #out = image.resize_to_fit(500,340)
      #out = image.resize_to_fit(540,360)
      out = image.resize_to_fit(648,432)

      
      if (image.orientation == Magick::LeftBottomOrientation )
         out = out.rotate(270)
         print "TRUE\n"
      end

      if (image.orientation == Magick::RightTopOrientation )
         out = out.rotate(90)
         print "TRUE\n"
      end
      
      if (image.orientation == Magick::BottomRightOrientation )
         out = out.rotate(180)
         print "TRUE\n"
      end
      
      
      med_size_path = "#{dir_name}/#{$MED_SIZE_PATH}"
      unless (File.exist?(med_size_path))
        Dir.mkdir(med_size_path)
      end
      out.write(file) { 
#         self.quality = 50
         if (image.orientation == Magick::LeftBottomOrientation ||
             image.orientation == Magick::RightTopOrientation  ||
             image.orientation == Magick::BottomRightOrientation) 
             self.orientation = Magick::TopLeftOrientation
         end 
      }
   end
   
  
end


# ARGV[0] - Directory path where the big files are located
if ARGV.length == 0
   puts "Usage:    <big_sized_file_target_directory>"
   exit false
end

$MED_SIZE_PATH = 'med_size'
  
Dir.glob("#{ARGV[0]}/*.JPG")  {
   |x| pic = Picture.new
       pic.thumb_size(x)
       pic.med_size(x)
       GC.start  }

