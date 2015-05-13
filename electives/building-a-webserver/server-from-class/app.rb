require 'sinatra'

class MyApp < Sinatra::Base
  get '/' do
    '<h1>Welcome to my app!</h1>' \
    '<p>What\'s your name?</p>' \
    '<form action="/greet" method="post" accept-charset="utf-8">'\
    '  <p><label for="name">Name</label><input type="text" name="name" value="" id="name"></p>'\
    '  <p><input type="submit" value="Greet"></p>'\
    '</form>'
  end

  get '/greet' do
    redirect '/'
  end

  post '/greet' do
    "<h1>Hello, #{params[:name]}</h1>"
  end
end
