require 'sinatra'
require_relative 'models/product.rb'

get '/' do
  @page_title = "Hasierako orria"
  render layout: "hasierakoLayout"
  erb :index
end

get '/erregistratu' do
  #ERREGISTRATZEKO ORRIA ERAKUSTEN DA HEMEN
  @page_title = "Erregistroa"
  layout :layout
  erb :erregistratu
end

get '/team' do
  # TEAM PAGE LISTING THE TEAM MEMBERS
  @page_title = "The Team"
  erb :team
end

get '/products' do
  # PRODUCTS PAGE LISTING ALL THE PRODUCTS
  @page_title = "All Products"
  @products = Product.sample_locations
  erb :products
end

get '/products/location/:location' do
  # PAGE DISPLAYING ALL PHOTOS FROM ONE LOCATION
  @products = Product.find_by_location(params[:location])
  @page_title =params[:location]
  erb :category
end

get '/products/:id' do
  # PAGE DISPLAYING ONE PRODUCT WITH A GIVEN ID
  @product = Product.find(params[:id].to_i)
  @page_title = @product.title
  erb :single
end

get '/deals' do
  # PAGE LISTING ALL PRODUCTS UNDER $10
  @products = Product.find_deals
  erb :deals
 end
