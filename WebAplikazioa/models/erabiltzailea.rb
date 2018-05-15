require 'httparty'
require 'json'
require 'active_model'

class Erabiltzailea
	include ActiveModel::Validations

	attr_accessor :id, :izena, :abizena, :korreoa, :hiria, :erabIzena, :pasahitza, :pasahitza2

	validates :izena, :format => {with: /[A-Za-z]{1,15}/, message: "izenaren formatu desegokia"}
	validates :abizena, format: {with: /[A-Za-z]{1,25}/, message: "abizenaren formatu desegokia"}
	validates :korreoa, format: {with: /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}/, message: "korreoak emaila@emaila.emaila 
	 formatua izan behar du"}#, uniqueness: true
	validates :hiria, format: {with: /[A-Za-z]{0,25}/, message: "hiriaren formatu desegokia"}
	validates :erabIzena, format: {with: /[A-Za-z]{1,15}/, message: "erabiltzaile izenaren formatu desegokia"}#, uniqueness: true
	validates :pasahitza, format: {with: /[A-Za-z0-9]{4,25}/, message: "pasahitzak gutxienez lau luzerakoa"}
	validate :pasahitzak_berdinak

	def pasahitzak_berdinak
		errors.add(:pasahitza2, "pasahitzak ez dira berdinak") if (pasahitza != pasahitza2)
	end

	def bakarra
	   File.open('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/data/erabiltzailea.json', "r+") do |f|
	  	hash = JSON.parse(f.read)
	  	puts hash["erabiltzaileak"]["izena"]
	  end
	end

	#def initialize(erabiltzaile_data)
	  #@id = erabiltzaile_data[:id]
	  #@izena = erabiltzaile_data[:izena]
	  #@abizena = erabiltzaile_data[:abizena]
	  #@korreoa = erabiltzaile_data[:korreoa]
	  #@hiria = erabiltzaile_data[:hiria]
	  #@erabIzena = erabiltzaile_data[:erabIzena]
	  #@pasahitza = erabiltzaile_data[:pasahitza]
	#end
	
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

	def self.save
	  map = {
	  		"id" => @id ,
			"izena" => @izena,
			"abizena" => @abizena,
			"korreoa" => @korreoa,
			"hiria" => @hiria,
			"erabIzena" => @erabIzena,
			"pasahitza" => @pasahitza
	  }
	  File.open('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/data/erabiltzailea.json', "r+") do |f|
	  hash = JSON.parse(f.read)
	  hash["erabiltzaileak"].push(map)
	  File.open('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/data/erabiltzailea.json', "w+") do |fi| 
	  fi.write(hash.to_json)
	  end
	  end
	end

	#id-a daukan pertsona itzuli
	def self.find(id)
	  self.all.select{|erabiltzailea| erabiltzailea.id == id}.first
	end
end
