require 'socket'

class RemoteObjectClient
  def initialize(host, port)
    @host = host
    @port = port
  end
  def checkStatus
    message = []
    message << "status"
    message << ""
    result = messageServer(message)
  end
  def makeNewThread
    result = ''
    message = []
    message << "new process"
    message << ""
    result = messageServer(message)
  end
  def messageServer(message)
    result = ""
    begin
      s = TCPSocket.open(@host,@port)
      puts "Successfully opened connection"
      message.each {|line| s.puts(line)}
      while line = s.gets
        result = result + line.chop
      end
      s.close
    rescue Exception => e
      result = e.message
    end
    return result
  end
end
