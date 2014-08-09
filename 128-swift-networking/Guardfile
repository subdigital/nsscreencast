# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(/(.*).swift/) do |m|
    puts
    puts
    puts
    puts "Running #{m[0]}"
    puts `swift #{m[0]} -sdk $(xcrun --show-sdk-path --sdk macosx)`
  end
end
