require 'socket'
require 'stringio'

class Request
  def self.parse(stream)
    env = {}

    # first row
    method, path, protocol = stream.gets.chomp.split
    env['REQUEST_METHOD']  = method
    env['PATH_INFO']       = path
    env['SERVER_PROTOCOL'] = protocol

    # headers
    loop do
      line = stream.gets
      break if line == "\r\n"
      key, value = parse_header(line)
      env[key] = value
    end

    # body
    length = env['CONTENT_LENGTH'].to_i
    stream = StringIO.new stream.read length
    env['rack.input'] = stream

    env
  end

  def self.parse_header(line)
    key, value = line.chomp.split(": ")
    key = key.upcase.gsub "-", "_"
    key = "HTTP_#{key}" unless key == 'CONTENT_TYPE' || key == 'CONTENT_LENGTH'
    [key, value]
  end
end


class Response
  def self.to_http(code, headers, body)
    response = "HTTP/1.1 #{code}\r\n"
    headers.each { |key, value| response << "#{key}: #{value}\r\n" }
    response << "\r\n"
    body.each { |line| response << line }
    response
  end
end

class MahWebserver
  def initialize(port, &webapp)
    @port   = port
    @webapp = webapp
  end

  def start
    @server = TCPServer.new(@port)
    loop do
      client = @server.accept
      env    = Request.parse(client)
      code, headers, body = @webapp.call(env)
      response = Response.to_http(code, headers, body)
      client.print(response)
      client.close
    end
  end

  def stop
    @server.close_read
    @server.close_write
  end
end
