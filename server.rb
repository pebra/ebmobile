require 'sinatra'
set :public_folder, "./www"
set :port, 3506
set :bind, "0.0.0.0"
get "/" do
  redirect '/index.html'
end
