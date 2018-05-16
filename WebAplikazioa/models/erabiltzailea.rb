require 'json'
require 'active_model'

class Erabiltzailea
	include ActiveModel::Validations

	attr_accessor :id, :izena, :abizena, :korreoa, :hiria, :erabIzena, :pasahitza, :pasahitza2

	validates :izena, :format => {with: /[A-Za-z]{1,15}/, message: "izenaren formatu desegokia"}
	validates :abizena, format: {with: /[A-Za-z]{1,25}/, message: "abizenaren formatu desegokia"}
	validates :korreoa, format: {with: /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}/, message: "korreoak emaila@emaila.emaila 
	 formatua izan behar du"}
	validates :hiria, format: {with: /[A-Za-z]{0,25}/, message: "hiriaren formatu desegokia"}
	validates :erabIzena, format: {with: /[A-Za-z]{1,15}/, message: "erabiltzaile izenaren formatu desegokia"}
	validates :pasahitza, format: {with: /[A-Za-z0-9]{4,25}/, message: "pasahitzak gutxienez lau luzerakoa"}
	validate :pasahitzak_berdinak, :bakarra

	def pasahitzak_berdinak
		errors.add(:pasahitza2, "pasahitzak ez dira berdinak") if (pasahitza != pasahitza2)
	end

	helbidea = File.join(File.dirname(__FILE__),'../data/erabiltzailea.json')
	DATA = File.read(helbidea)

	#def initialize(erabiltzaile_data)
	  #@id = erabiltzaile_data['id']
	  #@izena = erabiltzaile_data['izena']
	  #@abizena = erabiltzaile_data['abizena']
	  #@korreoa = erabiltzaile_data['korreoa']
	  #@hiria = erabiltzaile_data['hiria']
	  #@erabIzena = erabiltzaile_data['erabIzena']
	  #@pasahitza = erabiltzaile_data['pasahitza']
	#end

	def bakarra
		hash = JSON.parse(DATA)
		@erabiltzaileak = hash["erabiltzaileak"]
		puts erabIzena
		puts korreoa
		@erabIzenak = @erabiltzaileak.collect{| erab | erab["erabIzena"] == erabIzena}
		@korreoak = @erabiltzaileak.collect{| erab | erab["korreoa"] == korreoa}
		errors.add(:erabIzena, "erabiltzaile izen hori jada hartuta dago") if @erabIzenak.any?
		errors.add(:korreoa, "korreo hori jada hartuta dago") if @korreoak.any?
	end
	
	# Pertsona objektuen Array-a itzuli
	def self.all
	  DATA.map {|erabiltzailea| new(erabiltzailea)}
	end

	#def self.new(izena, abizena, korreoa, hiria, erabIzena, pasahitza, pasahitza2)
	  #@id = 2
	  #@izena = :izena
	  #@abizena = :abizena
	  #@korreoa = :korreoa
	  #@hiria = :hiria
	  #@erabIzena = :erabIzena
	  #@pasahitza = :pasahitza
	  #return self
	#end

	def save
		hash = JSON.parse(DATA)
		zenb = hash["erabiltzaileak"].length
		zenb = zenb +1
	  map = {
	  		"id" => zenb,
			"izena" => @izena,
			"abizena" => @abizena,
			"korreoa" => @korreoa,
			"hiria" => @hiria,
			"erabIzena" => @erabIzena,
			"pasahitza" => @pasahitza
	  }
	  helbidea = File.join(File.dirname(__FILE__),'../data/erabiltzailea.json')
	  File.open(helbidea, "r+") do |f|
	  hash = JSON.parse(f.read)
	  hash["erabiltzaileak"].push(map)
	  File.open(helbidea, "w+") do |fi| 
	  fi.write(hash.to_json)
	  end
	  end
	end

	#id-a daukan pertsona itzuli
	def self.find(id)
	  self.all.select{|erabiltzailea| erabiltzailea.id == id}.first
	end
end
