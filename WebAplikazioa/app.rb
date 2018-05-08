require 'sinatra'
require_relative 'models/erabiltzailea.rb'

get '/' do
  #HASIERAKO ORRIA
  @page_title = "Hasierako orria"
  @orria = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/index.erb')
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

post '/erabiltzailea' do
  #sign-up egitean hemen kontrolatuko dugu egin beharrekoa, hau da, erabiltzaile berria sortzea.
  @user = Erabiltzailea.new(izena: params[:izena], abizena: params[:abizena], korreoa: params[:korreoa], hiria: params[:hiria], erabIzena: params[:erabIzena], pasahitza: params[:pasahitza], pasahitza2: params[:pasahitza2])
  @user.save
end
