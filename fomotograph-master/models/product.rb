require 'httparty'
require 'json'

class Product
	
	# read access for the Product attributes
  	attr_reader :id, :title, :location, :summary, :url, :price

	#ping the API for the product JSON
	url = 'https://fomotograph-api.udacity.com/products.json'
	DATA = HTTParty.get(url)['photos']
	# locations offered by Fomotograph
	LOCATIONS = ['canada', 'england', 'france', 'ireland', 'mexico', 'scotland', 'taiwan', 'us']
	
	# initialize a Product object using a data hash
	def initialize(product_data = {})
	  @id = product_data['id']
	  @title = product_data['title']
	  @location = product_data['location']
	  @summary = product_data['summary']
	  @url = product_data['url']
	  @price = product_data['price']
	end
	
	# return an array of Product objects
	def self.all
	  DATA.map {|product| new(product)}
	end
	
	# return an array of sample products from each location
	def self.sample_locations
	  @products = LOCATIONS.collect{ |loc| self.all.select{ |product| product.location ==loc }.sample}
	  return @products
	end
	
	def self.find_by_location(loc = 'canada')
	  self.all.select { |product| product.location == loc }
	  #bi moduetara @products = DATA.select{|product| product['location'] == loc}
	end
	
	def self.find(id)
	  self.all.select{|product| product.id == id}.first
	end
	
	def self.find_deals
	  self.all.select{ |product| product.price < 10}
	end
end
