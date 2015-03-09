require 'mah_webserver'
require 'rest-client'


RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server = MahWebserver.new(3000) do |request, response|
      response.code = 200
      response.headers[:omg] = 'bbq'
      response.body = "hello, class ^_^"
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    response = RestClient.get 'localhost:3000/users'
    server.stop
    thread.join

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end
end
