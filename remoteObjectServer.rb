require 'socket'

class RemoteObjectServer
  def initialize(port)
    @server = TCPServer.new port # Server bind to port 2000
    @itterate = true
    @processes = {}
    @status = {}
    startListenining
  end
  def startListenining
    # sleep(10)
    while(@itterate)
      client = @server.accept    # Wait for a client to connect
      result = ""
      puts "Attempting to read from client..."
      while l = client.gets
        if(l.chop=="")
          break
        else
          result = l.chop
        end
      end
      result = result.downcase
      puts result

      methodMap = {}
      methodMap["exit"] = Proc.new {returnToClient(client, ["BYE"])}
      methodMap["new process"] = Proc.new {makeNewProcess(client)}
      methodMap["time"] = Proc.new {returnToClient(client, ["#{Time.now}"])}
      methodMap["error"] = Proc.new {returnToClient(client, ["ERROR!!"])}

      data = []
      @status.each {|key, value| data << key.to_s+":"+value.to_s }
      methodMap["status"] = Proc.new{returnToClient(client, data)}

      m = methodMap[result]

      if(m!=nil)
        puts "method is not null"
        m.call
      else
        methodMap["error"].call
      end
    end
    @server.close
  end
  def returnToClient(client, lst)
    message = ""
    lst.each do |str|
      message = message + ((message == "") ? "" : "|") + str.to_s
    end
    client.puts message
    client.close
  end
  def makeNewProcess(client)
    id = initiateProcess
    returnToClient(client, [id])
  end
  def initiateProcess
    puts "making a new process"
    keys = @processes.keys
    next_id = 0
    if(keys!=nil && keys.length!=0)
      next_id = keys.sort.reverse[0]+1
    end
    @processes[next_id]=Thread.new do
      100.times do |i|
        @status[next_id] = i
        sleep(1)
      end
      puts "done executing thread..."
      @status[next_id] = "done" 
    end
    return next_id
  end
end
