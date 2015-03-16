require_relative 'lib/mah_webserver'
require_relative 'app'
require 'pp'

port = "3000"
puts "Go to localhost:#{port} in the browser!"

server = MahWebserver.new(port) do |env|
  puts "REQUEST CAME IN!"
  pp env
  code, headers, body = MyApp.call env
  puts "HERE IS THE RESPONSE:"
  puts "CODE:    #{code}"
  puts "HEADERS: #{headers.inspect}"
  puts "BODY:    #{body.inspect}"
  puts "-" * 80
  [code, headers, body]
end

server.start
