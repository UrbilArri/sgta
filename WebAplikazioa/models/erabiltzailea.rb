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

	DATA = JSON.parse(File.read(File.join(File.dirname(__FILE__),'../data/erabiltzailea.json')))["erabiltzaileak"]

	def self.all
		return DATA.map {|erabiltzailea| self.new(erabiltzailea)}
	end

	def initialize(erabiltzaile_data)
	  @id = erabiltzaile_data['id']
	  @izena = erabiltzaile_data['izena']
	  @abizena = erabiltzaile_data['abizena']
	  @korreoa = erabiltzaile_data['korreoa']
	  @hiria = erabiltzaile_data['hiria']
	  @erabIzena = erabiltzaile_data['erabIzena']
	  @pasahitza = erabiltzaile_data['pasahitza']
	  @pasahitza2 = erabiltzaile_data['pasahitza2']
	end

	def bakarra
		@erabIzenak = DATA.collect{| erab | erab["erabIzena"] == erabIzena}
		@korreoak = DATA.collect{| erab | erab["korreoa"] == korreoa}
		errors.add(:erabIzena, "erabiltzaile izen hori jada hartuta dago") if @erabIzenak.any?
		errors.add(:korreoa, "korreo hori jada hartuta dago") if @korreoak.any?
	end


	def self.hurrengoId
		zenb = self.all.length
		zenb = zenb +1
		return zenb
	end

	def save
	  map = {
	  		"id" => @id,
			"izena" => @izena,
			"abizena" => @abizena,
			"korreoa" => @korreoa,
			"hiria" => @hiria,
			"erabIzena" => @erabIzena,
			"pasahitza" => @pasahitza
	  }
	  helbidea = File.join(File.dirname(__FILE__),'../data/erabiltzailea.json')
	  DATA.push(map)
	  mapa = {"erabiltzaileak" => DATA}
	  File.open(helbidea, "w+") do |fi| 
	  fi.write(mapa.to_json)
	  end
	end

	def update
	  
          helbidea = File.join(File.dirname(__FILE__),'../data/erabiltzailea.json')
	  DATA[@id-1]["izena"]=@izena
          DATA[@id-1]["abizena"]=@abizena
          DATA[@id-1]["korreoa"]=@korreoa
          DATA[@id-1]["hiria"]=@hiria
          DATA[@id-1]["erabIzena"]=@erabIzena
          DATA[@id-1]["pasahitza"]=@pasahitza
          mapa = {"erabiltzaileak" => DATA}
	  File.open(helbidea, "w+") do |fi| 
	  fi.write(mapa.to_json)
	  end
	end

	#id-a daukan pertsona itzuli
	def self.find(id)
	  self.all.find{|erabiltzailea| erabiltzailea.id == id}
	end

	def self.find_by_erab(erabIzena, pasahitza)
	  self.all.find{|erabiltzailea| erabiltzailea.erabIzena == erabIzena and erabiltzailea.pasahitza == pasahitza}
	end
end
