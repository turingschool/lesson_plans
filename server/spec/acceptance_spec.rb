require 'rest-client'

RSpec.describe 'server' do
  it 'parses a request and serves a 301' do
    server = Server.new port: 8889 do |request, response|
      # make sure the request looks right
      expect(request.method ).to eq 'GET'
      expect(request.path   ).to eq '/zomg'
      expect(request.version).to eq 'HTTP/1.1'

      expect(request.headers['User-Agent']).to eq 'idk rest client or something'
      expect(request.headers['Host']      ).to eq 'localhost:8889'
      expect(request.headers['Accept']    ).to eq '*/*'

      expect(request.body).to eq ''


      # set the response
      response.status_code = 301
      response.headers = {
        'Location'       => 'http://www.google.com/',
        'Content-Type'   => 'text/html; charset=UTF-8',
        'Content-Length' => '219',
      }

      response.body = [
        '<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8"',
        '<TITLE>301 Moved</TITLE></HEAD><BODY',
        '<H1>301 Moved</H1',
        'The document has move',
        '<A HREF="http://www.google.com/">here</A>.',
        '</BODY></HTML>',
      ]
    end

    server.start
    response = RestClient.get 'http://localhost:8889/zomg'
    server.stop

    # make sure the response looks right
    require "pry"
    binding.pry # assert this stuff below
    response.status_code = 301
    response.headers = {
      'Location'       => 'http://www.google.com/',
      'Content-Type'   => 'text/html; charset=UTF-8',
      'Content-Length' => '219',
    }

    response.body = [
      '<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8"',
      '<TITLE>301 Moved</TITLE></HEAD><BODY',
      '<H1>301 Moved</H1',
      'The document has move',
      '<A HREF="http://www.google.com/">here</A>.',
      '</BODY></HTML>',
    ]
  end
end
