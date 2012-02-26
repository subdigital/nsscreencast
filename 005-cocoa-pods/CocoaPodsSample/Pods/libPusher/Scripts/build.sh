#!/bin/sh
echo "*****************************"
echo "UPDATING PROJECT DEPENDENCIES "
echo "*****************************"

echo "* Updating gems for MacRuby"
source "$HOME/.rvm/scripts/rvm"
rvm use macruby-nightly > /dev/null
bundle install --without building scripts > /dev/null

echo "* Updating CocoaPods"
bundle exec pod install > /dev/null
echo ""

echo "*****************************"
echo "PREPARING FOR BUILD"
echo "*****************************"

echo "* Updating gems for MRI"
rvm use default
bundle install --without macruby
echo ""

bundle exec rake release:combined
