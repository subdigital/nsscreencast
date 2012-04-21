set -e

xcodebuild -workspace MrJenkins/MrJenkins.xcworkspace/ -scheme MrJenkinsTests -configuration Debug -sdk iphonesimulator | scripts/ocunit2junit.rb
