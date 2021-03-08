
def run_applescript(file,script)
  command = <<~SCRIPT
    tell application "Adobe InDesign 2021" 
      open "#{file}" 
      do script "#{script}" with arguments {} language javascript
    end tell
  SCRIPT
  $stderr.puts command
  `osascript -e '#{command}'`
end

script = File.expand_path("./script.jsx")
file = File.expand_path("./file.indd")

run_applescript(file,script)


