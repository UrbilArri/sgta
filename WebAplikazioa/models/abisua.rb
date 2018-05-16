require 'json'
require 'active_model'

class Abisua 
	include ActiveModel::Validations

attr_accessor :id, :data, :mota, :probintzia, :hiria, :errepidea, :iruzkina

validates :hiria, format: {with: /[A-Za-z]{2,35}/, message: "hiriaren formatu desegokia"}
validates :errepidea, format: {with: /[A-Z]{0,3}+-[0-9]{1,4}/, message: "errepidearen formatu desegokia"}


helbidea = File.join(File.dirname(__FILE__),'../data/abisua.json')
DATA = File.read(helbidea)

def save 
	hash = JSON.parse(DATA)
	zenb = hash["abisuak"].length
	zenb = zenb +1
	map = {
	  		"id" => zenb,
			"data" => @data,
			"mota" => @mota,
			"probintzia" => @probintzia,
			"hiria" => @hiria,
			"errepidea" => @errepidea,
			"iruzkina" => @iruzkina
	  }
	  helbidea = File.join(File.dirname(__FILE__),'../data/abisua.json')
	  File.open(helbidea, "r+") do |f|
	  hash = JSON.parse(f.read)
	  hash["abisuak"].push(map)
	  File.open(helbidea, "w+") do |fi| 
	  fi.write(hash.to_json)
	  end
	  end
end

def self.denak
	hash = JSON(DATA)
	return hash["abisuak"]
end

end