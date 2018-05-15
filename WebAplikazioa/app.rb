require 'sinatra'
require_relative 'models/erabiltzailea.rb'
require 'erb'

get '/' do
  #HASIERAKO ORRIA
  @page_title = "Hasierako orria"
  @orria = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/index.erb')
  erb :hasierakoLayout
end

get '/erregistroak/erregistratu' do
  #ERREGISTRATZEKO ORRIA ERAKUSTEN DA HEMEN
  @page_title = "Erregistroa"
  @fitx = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/erregistroak/erregistratu.erb')
  @orria = ERB.new(@fitx).result()
  erb :hasierakoLayout
end

get '/sesioak/login' do
  #LOGEATZEKO ORRIA
  @page_title = "Logeatu"
  @orria = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/views/sesioak/login.erb')
  erb :hasierakoLayout
end

post '/erregistroak' do
  #sign-up egitean hemen kontrolatuko dugu egin beharrekoa, hau da, erabiltzaile berria sortzea.
  @user = Erabiltzailea.new
  @user.izena = params[:izena] 
  @user.abizena = params[:abizena]
  @user.korreoa = params[:korreoa]
  @user.hiria = params[:hiria]
  @user.erabIzena = params[:erabIzena]
  @user.pasahitza = params[:pasahitza]
  @user.pasahitza2 = params[:pasahitza2]
  if @user.valid?
    @user.save
  else
  end
end
