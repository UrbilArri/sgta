require 'json'
require 'active_model'

class Abisua 
	include ActiveModel::Validations

attr_accessor :id, :data, :mota, :probintzia, :hiria, :errepidea, :iruzkina

validates :hiria, format: {with: /[A-Za-z]{2,35}/, message: "hiriaren formatu desegokia"}
validates :errepidea, format: {with: /[A-Z]{0,3}+-[0-9]{1,4}/, message: "errepidearen formatu desegokia"}

DATA = (JSON.parse(File.read(File.join(File.dirname(__FILE__),'../data/abisua.json'))))["abisuak"]

def self.all
		return DATA.map {|abisua| self.new(abisua)}
end

def self.hurrengoId
		zenb = self.all.length
		zenb = zenb +1
		return zenb 
end

def initialize(abisu_data)
	  @id = abisu_data['id']
	  @data = abisu_data['data']
	  @mota = abisu_data['mota']
	  @probintzia = abisu_data['probintzia']
	  @hiria = abisu_data['hiria']
	  @errepidea = abisu_data['errepidea']
	  @iruzkina = abisu_data['iruzkina']
end

def save 
	map = {
	  		"id" => @id,
			"data" => @data,
			"mota" => @mota,
			"probintzia" => @probintzia,
			"hiria" => @hiria,
			"errepidea" => @errepidea,
			"iruzkina" => @iruzkina
	  }
	  helbidea = File.join(File.dirname(__FILE__),'../data/abisua.json')
	  DATA.push(map)
	  File.open(helbidea, "w+") do |fi| 
	  fi.write(DATA.to_json)
	  end
end

def self.find(id)
	return self.all.find{|ab| ab.id == Integer(id)}
end

end