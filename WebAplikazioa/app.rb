require 'sinatra'
require_relative 'models/pertsona.rb'

get '/' do
  #HASIERAKO ORRIA
  @page_title = "Hasierako orria"
  @orria = File.read('views/index.erb')
  erb :hasierakoLayout
end

get '/erregistratu' do
  #ERREGISTRATZEKO ORRIA ERAKUSTEN DA HEMEN
  @page_title = "Erregistroa"
  @orria = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/erregistratu.erb')
  erb :hasierakoLayout
end

get '/login' do
  #LOGEATZEKO ORRIA
  @page_title = "Logeatu"
  @orria = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/login.erb')
  erb :hasierakoLayout
end
