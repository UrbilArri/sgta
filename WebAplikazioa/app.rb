require 'sinatra'
require_relative 'models/erabiltzailea.rb'
require 'erb'

get '/' do
  #HASIERAKO ORRIA
  @page_title = "Hasierako orria"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  erb :index
end

get '/erregistratu' do
  #ERREGISTRATZEKO ORRIA ERAKUSTEN DA HEMEN
  @page_title = "Erregistroa"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  erb :erregistratu
end

get '/login' do
  #LOGEATZEKO ORRIA
  @page_title = "Logeatu"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  erb :login
end

post '/erregistroa' do
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
    @erroreak = @user.errors
    @page_title = "Erregistroa"
    @esteka1 = '/erregistratu'
    @esteka2 = 'login'
    @para = params
    erb :erregistratu
  end
end
