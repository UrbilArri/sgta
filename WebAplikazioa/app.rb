require 'sinatra'
require_relative 'models/erabiltzailea.rb'
require_relative 'models/abisua.rb'
require 'cgi'
require 'cgi/session'
require 'cgi/session/pstore' 

cgi = CGI.new("html4")

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

post '/login' do
  #login egitean hemen kontrolatuko dugu egin beharrekoa, hau da, sesio berri bat sortzea.
  @izena = params[:erabIzena]
  @pass = params[:pasahitza]
  if @izena.eql? '' or @pass.eql? ''
    @erroreak = 'Erabiltzailea eta pasahitza sartu behar dira'
    @page_title = "Logeatu"
    @esteka1 = '/erregistratu'
    @esteka2 = 'login'
    erb :login
  else
    @user = Erabiltzailea.find_by_erab(@izena, @pass)
    if @user
      session = CGI::Session
      session[:user_id] = @user.id
      session[:user_email] = @user.korreoa
      session[:user_name] = @user.erabIzena
      redirect '/abisuak'
    else
      @erroreak = 'Erabiltzaile edo pasahitz desegokiak'
      @page_title = "Logeatu"
      @esteka1 = '/erregistratu'
      @esteka2 = 'login'
      erb :login
    end
  end
end

post '/erregistratu' do
  #sign-up egitean hemen kontrolatuko dugu egin beharrekoa, hau da, erabiltzaile berria sortzea.
  @user = Erabiltzailea.new({"id" => Erabiltzailea.hurrengoId,
  "izena" => params[:izena], 
  "abizena" => params[:abizena], 
  "korreoa" => params[:korreoa], 
  "hiria" => params[:hiria], 
  "erabIzena" => params[:erabIzena], 
  "pasahitza" => params[:pasahitza], 
  "pasahitza2" => params[:pasahitza2]})
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
  @abisua = Abisua.new({"id" => Abisua.hurrengoId,
   "data" => Time.now ,
   "mota" => params[:mota],
   "probintzia" => params[:probintzia],
   "hiria" => params[:hiria],
   "errepidea" => params[:errepidea],
   "iruzkina" => params[:iruzkina] })
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
  if session[:user_id]
    @page_title = "Abisuak"
    @esteka1 = '/logout'
    @esteka2 = '/profila'
    @izen1 = "log out"
    @izen2 = "profila"
    @abisuak = Abisua.all
    @sesioa = session
    erb :abisuak
  else 
    redirect '/login'
  end
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

get '/profila' do
  #Profila editatzeko horria
  puts session[:user_id]
  if session[:user_id]
    @page_title = "Profila editatu"
    erb :profila
  else
    redirect '/login'
  end
end