xctool -workspace LoginTester.xcworkspace \
       -scheme LoginTesterTests \
       -sdk iphonesimulator \
       clean build test \
       ONLY_ACTIVE_ARCH=NO
