require File.expand_path(File.join(File.dirname(__FILE__), *%w[auth_server]))
run Pusher::FakeAuthServer
