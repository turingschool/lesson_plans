require 'mah_webserver'
require 'rest-client'

RSpec.describe 'Acceptance test' do
  it 'accepts and responds to a web request' do
    server = MahWebserver.new(3000) do |env|
      expect(env['PATH_INFO']).to eq '/users'
      body = "hello, class ^_^"
      headers = {
        'Content-Type'   => 'text/plain',
        'Content-Length' => body.length,
        'omg'            => 'bbq'
      }
      [200, headers, [body]]
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    response = RestClient.get 'localhost:3000/users'
    thread.kill
    server.stop

    expect(response.code).to eq 200
    expect(response.headers[:omg]).to eq 'bbq'
    expect(response.body).to eq "hello, class ^_^"
  end

  it 'handles multiple requests' do
    server = MahWebserver.new(3000) do |env|
      [200, {'Content-Type' => 'text/plain'}, []]
    end

    thread = Thread.new { server.start }
    thread.abort_on_exception = true

    expect(RestClient.get('localhost:3000/').code).to eq 200
    expect(RestClient.get('localhost:3000/').code).to eq 200

    thread.kill
    server.stop
  end
end
