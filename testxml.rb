#!/opt/local/bin/ruby
require 'rubygems'
require 'xmlsimple'
require 'exifr'

$THUMBS_PATH = 'thumbs'
$MED_SIZE_PATH = 'med_size'

=begin
galleries_ref = {
"gallery" => {
  "base"=>"",
  "background"=>"#FFFFFF",
  "banner"=>{"fontsize"=>"3", "content"=>" ", "color"=>"#F0F0F0", "font"=>"Arial"}, 
  "security"=>[{}],
  "thumbnail"=>[{"col"=>"5", "border"=>"0", "fontsize"=>"4", "content"=>" ", "rows"=>"3", "color"=>"#F0F0F0", "font"=>"Arial", "base"=>"#{$THUMBS_PATH}/"}], 
  "text"=>"#000000", 
  "date"=>"4/11/2006", 
  "photos" => [{"photo"=>[],
                "id"   =>"images"}
              ],
  "vlink"=>"#800080",
  "contactinfo"=>[{}],
#  "sitename"=>["China Gallery"],
  "sitename"=>[],
  "link"=>"#0000FF", 
  "large"=>[{"border"=>"0", "fontsize"=>"3", "content"=>" ", "color"=>"#F0F0F0", "font"=>"Arial", "base"=>"#{$MED_SIZE_PATH}/"}], 
  "photographer"=>[{}], 
  "alink"=>"#FF0000", 
  "email"=>[{}],

             }
        }

        
Dir.glob("#{ARGV[0]}/*.JPG")  {
   |y| x = File.expand_path(y)
   puts "#{x}"
   base_name = File.basename(x)
   base_name_wo_suffix = File.basename(x,".JPG")
   width = EXIFR::JPEG.new(x).width
   height = EXIFR::JPEG.new(x).height
   ref["gallery"]["sitename"] << File.basename( File.dirname( File.dirname(x) ) )
   ref["gallery"]["photos"][0]["photo"] << {
       "path" => base_name,
       "thumbpath" => "#{base_name_wo_suffix}.GIF",
       "thumbwidth" => 75,
       "thumbheight" => 75,
       "width" => width,
       "height" => height
   }
}
=end


ref = config = XmlSimple.xml_in(ARGV[0], 'KeepRoot' => true)
p config
#xml = XmlSimple.xml_out(ref, 'OutputFile' => "#{ARGV[0]}/../photos.xml", 'RootName' => nil)

