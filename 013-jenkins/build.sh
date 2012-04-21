set -e

xcodebuild -workspace MrJenkins/MrJenkins.xcworkspace/ -scheme MrJenkins -configuration Debug -sdk iphonesimulator clean build
