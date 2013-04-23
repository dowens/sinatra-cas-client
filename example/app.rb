require 'sinatra/base'
require 'sinatra/cas/client'

class MyApp < Sinatra::Base
  register Sinatra::CAS::Client

  set :cas_base_url, 'https://login.example.com/cas'
  set :service_url, 'http://localhost:8000'
  set :console_debugging, true

  set :port, 8000

  get '/' do
    if authenticated?
      session[:cas_user]
    else
      "My hovercraft is full of eels."
    end
  end

  run!
end

