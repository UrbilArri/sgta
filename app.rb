require 'sinatra'
require_relative 'models/erabiltzailea.rb'
require_relative 'models/abisua.rb'
require 'cgi'
require 'cgi/session'

cgi = CGI.new("html4")

get '/' do
  #HASIERAKO ORRIA
  begin
    session = CGI::Session.new(cgi, 'new_session' => false)
    @page_title = "Hasierako orria"
    @esteka1 = '/profila'
    @esteka2 = '/logout'
    @izen1 = "profila"
    @izen2 = "log out"
    session.close
  rescue ArgumentError
    @page_title = "Hasierako orria"
    @esteka1 = '/erregistratu'
    @esteka2 = 'login'
    @izen1 = "erregistratu"
    @izen2 = "log in"
  end
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
      begin
        session = CGI::Session.new(cgi, 'new_session' => false)
        session.delete
      rescue ArgumentError
        puts "arazoak"
    end
      session = CGI::Session.new(cgi, 'new_session' => true)
      session['user_id'] = @user.id
      session['user_email'] = @user.korreoa
      session['user_name'] = @user.erabIzena
      session.close
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
  begin
    session = CGI::Session.new(cgi, 'new_session' => false)
    @abisua = Abisua.new({"id" => Abisua.hurrengoId,
     "data" => Time.now ,
     "mota" => params[:mota],
     "probintzia" => params[:probintzia],
     "hiria" => params[:hiria],
     "errepidea" => params[:errepidea],
     "iruzkina" => params[:iruzkina] })
    if @abisua.valid?
      @abisua.save
      session.close
      redirect '/abisuak'
    else 
      @erroreak = @abisua.errors
      @page_title = "Abisua igo"
      @esteka1 = '/logout'
      @esteka2 = '/profila'
      @izen1 = "log out"
      @izen2 = "profila"
      @para = params
      session.close
      erb :abisuaIgo
    end
  rescue ArgumentError
    redirect '/login'
  end
end

get '/abisuak' do
  #abisu guztietara eramango gaitu
    begin 
      session = CGI::Session.new(cgi, 'new_session' => false)
      @page_title = "Abisuak"
      @esteka1 = '/logout'
      @esteka2 = '/profila'
      @izen1 = "log out"
      @izen2 = "profila"
      @abisuak = Abisua.all
      @sesioa = session
      erb :abisuak
      session.close
    rescue ArgumentError
      redirect '/login'
  end
end

get '/abisuaIgo' do
  begin
    session = CGI::Session.new(cgi, 'new_session' => false)
    @page_title = "Abisua igo"
    @esteka1 = '/logout'
    @esteka2 = '/profila'
    @izen1 = "log out"
    @izen2 = "profila"
    erb :abisuaIgo
    session.close
  rescue ArgumentError
    redirect '/login'
  end
end

get '/abisua/:id' do
  begin
    session = CGI::Session.new(cgi, 'new_session' => false)
    @abisua = Abisua.find(params[:id])
    @page_title = "Abisua"
    @esteka1 = '/logout'
    @esteka2 = '/profila'
    @izen1 = "log out"
    @izen2 = "profila"
    erb :abisua
    session.close
  rescue ArgumentError
    redirect '/login'
  end
end

get '/profila' do
#erabiltzailearen profila agertuko da
  begin
    session = CGI::Session.new(cgi, 'new_session' => false)
    @page_title = "Profila editatu"
    @esteka1 = '/logout'
    @esteka2 = '/profila'
    @izen1 = "log out"
    @izen2 = "profila"
    erb :profila
    session.close
  rescue ArgumentError
    redirect '/login'
  end
end

get '/logout' do

end