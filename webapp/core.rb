require 'sinatra'
require 'json'
require 'socket'
require_relative('../remoteObjectClient.rb')
require_relative('../configLoader')

configure do
  # setting one option
  set :option, 'value'

  # setting multiple options
  set :a => 1, :b => 2
  configs = ConfigLoader::LoadConfig.new.load
  set :tcp_host, configs["tcp_server"]["host"]
  set :tcp_port, configs["tcp_server"]["port"]
end

def connectAndDoAction(action)
  result = ""
  if(!settings.tcp_host? || !settings.tcp_port?)
    result = "SETTINGS NOT LOADED!!!"
  else
    host = settings.tcp_host
    port = settings.tcp_port
    begin
      client = RemoteObjectClient.new(host,port)
      result = action.call(client)
    rescue Exception => e
      result = e.message
    end
  end
  return result
end
post '/:action/:params' do
  args = params[:params].split(':')
  action = Proc.new {|client| client.doAction(params[:action], args)}
  connectAndDoAction(action)
end
post '/newprocess' do
  action = Proc.new {|client| client.makeNewThread}
  connectAndDoAction(action)
end

post '/status' do
  action = Proc.new do |client|
  	dataAsString = client.checkStatus
  	bits = dataAsString.chomp.split('|')
  	dataMap = {}
  	bits.each do |bit|
  		key_val = bit.split(":")
  		if(key_val!=nil && key_val.length==2)
  			dataMap[key_val[0]] = key_val[1]
  		end
  	end
  	dataMap.to_json
  end
  connectAndDoAction(action)
end

get '/' do
  erb :index
end
