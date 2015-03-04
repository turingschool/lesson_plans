class Server
  class Request
    def self.from_http(stream)
      request = self.new

      request.method, request.path, request.version =
        stream.gets.strip.split

      request.headers = {}
      loop do
        header = stream.gets
        break if header == "\r\n"
        key, value = header.split(": ", 2)
        request.headers[key] = value.chomp
      end

      request.body = ''
      request
    end

    attr_accessor :method, :path, :version, :headers, :body
  end
end
