def run_applescript(file,script,args)
  command = <<~SCRIPT
    tell application "Adobe InDesign 2021" 
      open "#{file}" 
      do script "#{script}" with arguments {"#{args}"} language javascript
    end tell
  SCRIPT
  $stderr.puts command
  `osascript -e '#{command}'`
end

script = File.expand_path("./script.jsx")

Dir.glob('**/*.indd').each do |f|

  if f.match(/cover/i)
    args = "cover"
  elsif f.match(/insides/i)
    args = "insides"
  end

  file = File.expand_path(f)
  run_applescript(file,script,args)
end
