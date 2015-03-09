require 'socket'

class Request
  def self.parse(stream)
    new
  end
end


class Response
  def to_http
    "HTTP/1.1 200 OK\r\n" +
    "Content-Type: text/html;charset=utf-8\r\n" +
    "X-XSS-Protection: 1; mode=block\r\n" +
    "X-Content-Type-Options: nosniff\r\n" +
    "X-Frame-Options: SAMEORIGIN\r\n" +
    "Content-Length: 16\r\n" +
    "omg: bbq\r\n" +
    "\r\n" +
    "hello, class ^_^"
  end
end

class MahWebserver
  def initialize(port, &webapp)
    @port = port
  end

  def start
    server   = TCPServer.new(@port)
    client   = server.accept
    request  = Request.parse(client)
    response = Response.new
    # call block ??
    client.print(response.to_http)
    client.close
  end

  def stop
  end
end
