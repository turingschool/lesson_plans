require 'mah_webserver'

RSpec.describe 'Response test' do
  it 'creates an HTTP response from a rack response' do
    http = Response.to_http(
      404,
      {'this-is-a-header' => 'and-a-value'},
      ["This is a body"]
    )

    expect(http).to eq \
      "HTTP/1.1 404\r\n" \
      "this-is-a-header: and-a-value\r\n" \
      "\r\n" \
      "This is a body"
  end
end
