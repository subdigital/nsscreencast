#!/bin/sh
source "$HOME/.rvm/scripts/rvm"
rvm use macruby-nightly
bundle install --without scripts building
rm -fr Pods
bundle exec pod install
rvm use default
