require 'sinatra'
require_relative 'models/erabiltzailea.rb'
require_relative 'models/abisua.rb'

get '/' do
  #HASIERAKO ORRIA
  @page_title = "Hasierako orria"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  @izen1 = "erregistratu"
  @izen2 = "log in"
  erb :index
end

get '/erregistratu' do
  #ERREGISTRATZEKO ORRIA ERAKUSTEN DA HEMEN
  @page_title = "Erregistroa"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  @izen1 = "erregistratu"
  @izen2 = "log in"
  erb :erregistratu
end

get '/login' do
  #LOGEATZEKO ORRIA
  @page_title = "Logeatu"
  @esteka1 = '/erregistratu'
  @esteka2 = 'login'
  @izen1 = "erregistratu"
  @izen2 = "log in"
  erb :login
end

post '/erregistratu' do
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
    redirect '/abisuak'
  else
    @erroreak = @user.errors
    @page_title = "Erregistroa"
    @esteka1 = '/erregistratu'
    @esteka2 = 'login'
    @izen1 = "erregistratu"
    @izen2 = "log in"
    @para = params
    erb :erregistratu
  end
end

post '/abisuaIgo' do
  @abisua = Abisua.new
  @abisua.data = Time.now
  @abisua.mota = params[:mota]
  @abisua.probintzia = params[:probintzia]
  @abisua.hiria = params[:hiria]
  @abisua.errepidea = params[:errepidea]
  @abisua.iruzkina = params[:iruzkina]
  if @abisua.valid?
    @abisua.save
    redirect '/abisuak'
  else 
    @erroreak = @abisua.errors
    @page_title = "Abisua igo"
    @esteka1 = '/logout'
    @esteka2 = '/profila'
    @izen1 = "log out"
    @izen2 = "profila"
    @para = params
    erb :abisuaIgo
  end
end

get '/abisuak' do
  #abisu guztietara eramango gaitu
  @page_title = "Abisuak"
  @esteka1 = '/logout'
  @esteka2 = '/profila'
  @izen1 = "log out"
  @izen2 = "profila"
  @abisuak = Abisua.denak
  erb :abisuak
end

get '/abisuaIgo' do
  @page_title = "Abisua igo"
  @esteka1 = '/logout'
  @esteka2 = '/profila'
  @izen1 = "log out"
  @izen2 = "profila"
  erb :abisuaIgo
end

get '/abisua/:id' do
  @abisua = Abisua.find(params[:id])
  @page_title = "Abisua"
  @esteka1 = '/logout'
  @esteka2 = '/profila'
  @izen1 = "log out"
  @izen2 = "profila"
  erb :abisua
end
