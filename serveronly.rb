require_relative('remoteObjectServer.rb')

port = 2222
host = "localhost"
puts "Starting server"
RemoteObjectServer.new(port)