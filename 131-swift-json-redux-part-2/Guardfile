# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(/JSONExample\/JSONExample\/(.*).swift/) do |m|
    puts
    puts
    puts `cd JSONExample && xcodebuild && ./build/Release/JSONExample`
  end
end
