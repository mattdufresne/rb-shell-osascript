def run_applescript(file,script)
  command = <<~SCRIPT
    tell application "Adobe InDesign 2020" 
      open "#{file}" 
      do script "#{script}" with arguments {} language javascript
    end tell
  SCRIPT
  $stderr.puts command
  `osascript -e '#{command}'`
end

script = File.expand_path("./script.jsx")

Dir.glob('**/*.indd').each do |f|
  file = File.expand_path(f)
  run_applescript(file,script)
end