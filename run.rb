require 'csv'
require 'fuzzystringmatch'


def run_applescript(cover_file,insides_file,script)
  command = <<~SCRIPT
    tell application "Adobe InDesign 2021" 
      open "#{cover_file}" 
      do script "#{script}" with arguments {"#{cover_file}", "#{insides_file}"} language javascript
    end tell
  SCRIPT
  $stderr.puts command
  `osascript -e '#{command}'`
end

script = File.expand_path("./script.jsx")
files = Dir.glob('**/*.indd')
books = Array.new

files.each_with_index do |f, index|
  if f.match(/cover/i)
    file = File.expand_path(f)
    file_dir = File.dirname(file)
    glob = Dir.glob("#{file_dir}/**/*.indd")

    cover_path = String.new
    inside_path = String.new

    if glob.length == 2
      glob.each do |g|
        book_cover = g.match(/cover/i)
        if g.match(/cover/i)
          cover_path = g
        end
        if g.match(/inside/i)
          inside_path = g
        end
      end
      jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
      confidence = jarow.getDistance("#{cover_path}", "#{inside_path}")
      books << {cover: cover_path, insides: inside_path, confidence: confidence}
    elsif glob.length == 1
      file_dir = File.expand_path("#{file_dir}/..") 
      glob_near = Dir.glob("#{file_dir}/**/*.indd")
      if glob_near.length == 2
        glob_near.each do |g|
          book_cover = g.match(/cover/i)
          if g.match(/cover/i)
            cover_path = g
          end
          if g.match(/inside/i)
            inside_path = g
          end
        end
        jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
        confidence = jarow.getDistance("#{cover_path}", "#{inside_path}")
        books << {cover: cover_path, insides: inside_path, confidence: confidence}
      end
    elsif glob.length > 2
      glob.each do |g|
        # To do
      end
    end
  end
end

books.each do |b|
  CSV.open("books.csv", "a+") do |csv|
    csv << ["Cover Path: #{b[:cover]}", "Insides Path: #{b[:insides]}", "confidence: #{b[:confidence]}"]
  end
  cover_file = File.expand_path(b[:cover])
  insides_file = File.expand_path(b[:insides])
  run_applescript(cover_file,insides_file,script)
end