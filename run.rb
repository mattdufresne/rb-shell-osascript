require 'fuzzystringmatch'


def run_applescript(file,script,companion_file)
  command = <<~SCRIPT
    tell application "Adobe InDesign 2021" 
      open "#{file}" 
      do script "#{script}" with arguments {"#{file}", "#{companion_file}"} language javascript
    end tell
  SCRIPT
  $stderr.puts command
  `osascript -e '#{command}'`
end

script = File.expand_path("./script.jsx")

files = Dir.glob('**/*.indd')
files.each_with_index do |f, index|
  if f.match(/cover/i)
    jarow = FuzzyStringMatch::JaroWinkler.create( :pure )

    if jarow.getDistance("#{f}", "#{files[index + 1]}") > 0.9
      companion_file = File.expand_path(files[index + 1])
      file = File.expand_path(f)
      run_applescript(file,script,companion_file)
    end


  elsif f.match(/insides/i)
    puts f
  end
end
