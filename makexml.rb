require 'rubygems'
require 'xmlsimple'
require 'exifr'

# ARGV[0] - Directory path where the medium sized files are located
if ARGV.length == 0
   puts "Usage:    <med_sized_file_target_directory>"
   exit false
end

$THUMBS_PATH = 'thumbs'
$MED_SIZE_PATH = 'med_size'

ref = {
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

=begin
galleries_ref = {"galleries"=>[ {
   "gallery"=>[{"security"=>[{}], 
                "contactinfo"=>[], 
                "sitename"=>[], 
                "photographer"=>[], 
                "email"=>[], 
                "file"=>"", 
                "base"=>"" }]
                             }  ]
                }
=end
galleries_ref = {"galleries"=>[ {
   "gallery"=>[]
                             }  ]
                }

# doc.elements.each["gallery"]
# doc.elements.last["gallery"]
# 
# last_gallery = doc.elements.last["gallery"]
# new_gallery = REXML::Element.new "gallery"
# photographer = REXML::Element.new "photographer"
# new_gallery << photographer
# doc.root.insert_after last_gallery, new_gallery

Dir.glob("#{ARGV[0]}/*.JPG")  {
   |w| x = File.expand_path(w)
   puts "#{x}"
   base_name = File.basename(x)
   base_name_wo_suffix = File.basename(x,".JPG")
   width = EXIFR::JPEG.new(x).width
   height = EXIFR::JPEG.new(x).height
   ref["gallery"]["photos"][0]["photo"] << {
       "path" => base_name,
       "thumbpath" => "#{base_name_wo_suffix}.GIF",
       "thumbwidth" => 75,
       "thumbheight" => 75,
       "width" => width,
       "height" => height
   }
}

sitename = File.basename( File.dirname( ARGV[0] ) )
ref["gallery"]["sitename"] << "#{sitename}/"

galleries_output_file = "#{ARGV[0]}/../../galleries.xml"
if File.exist?(galleries_output_file)
   galleries_ref = XmlSimple.xml_in(galleries_output_file, 'KeepRoot' => true)
end
if ( galleries_ref ["galleries"] [0] ["gallery"].select { |gallery| gallery["base"] == "#{sitename}/" } == [] ) 
   # need to insert
   puts "Inserting new entry in #{galleries_output_file}"
   galleries_ref ["galleries"] [0] ["gallery"] << {
       "security" =>  [{}],
       "contactinfo" => ["http://haoandelena.com"],
       "sitename" => [sitename],
       "photographer" => ["Elena Ching"],
       "email" => ["elena@haoandelena.com"],
       "file" => "photos.xml",
       "base" => "#{sitename}/"
    }
galleries_ref ["galleries"] [0] ["gallery"] =
    galleries_ref ["galleries"] [0] ["gallery"].sort_by { |gallery| gallery["sitename"] }
galleries_ref ["galleries"] [0] ["gallery"].reverse!
XmlSimple.xml_out(galleries_ref, 'OutputFile' => galleries_output_file, 'RootName' => nil)
else #A rerun of photos
#Do some clean up of thumbnails

   Dir.glob("#{ARGV[0]}/../#{$THUMBS_PATH}/*.GIF")  {
       |thumb_file| med_size_file = "#{ARGV[0]}/#{File.basename(thumb_file,".GIF")}.JPG"
        unless File.exist?(med_size_file)
            #remove thumb file if med_sized_file does not exist anymore
            puts "#{thumb_file} will be deleted! because #{med_size_file} doest NOT exist."
            File.delete(thumb_file)
        end
   }
end
#galleries_ref ["galleries"] [0] ["gallery"].sort_by { |gallery| gallery["sitename"] }.each do |gallery|
#          puts "#{gallery["sitename"]} #{gallery["base"]}"
#          end
#p galleries_ref
#XmlSimple.xml_out(galleries_ref, 'OutputFile' => galleries_output_file, 'RootName' => nil)

xml = XmlSimple.xml_out(ref, 'OutputFile' => "#{ARGV[0]}/../photos.xml", 'RootName' => nil)

