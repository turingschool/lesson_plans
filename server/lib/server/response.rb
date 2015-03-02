class Server
  class Response
    attr_accessor :status_code, :headers, :body

    def to_http
      http = "HTTP/1.1 #{status_code} Moved Permanently\r\n"
      headers.each { |key, value| http << "#{key}: #{value}\r\n" }
      http << "\r\n"
      body.each { |line| http << line << "\r\n" }
      http
    end
  end
end
