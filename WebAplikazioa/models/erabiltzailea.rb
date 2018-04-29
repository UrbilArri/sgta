require 'httparty'
require 'json'
require_relative 'application_record.rb'

class Pertsona < ApplicationRecord
	
	# read access for the Product attributes
	validates :izena, format: {with: /[A-Za-z]{1,15}/, message: "izenaren formatu desegokia"}
	validates :abizena, format: {with: /[A-Za-z]{1,25}/, message: "abizenaren formatu desegokia"}
	validates :korreoa, format: {with: /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}/, message: "korreoak emaila@emaila.emaila formatua izan behar du"}, uniqueness: true
	validates :hiria, format: {with: /[A-Za-z]{0,25}/, message: "hiriaren formatu desegokia"}
	validates :erabIzena, format: {with: /[A-Za-z]{1,15}/, message: "erabiltzaile izenaren formatu desegokia"}, uniqueness: true
	validate :pasahitzak_berdinak

	def pasahitzak_berdinak
		errors.add(:pasahitza2, "pasahitzak ez dira berdinak") if not(:pasahitza == :pasahitza2)
	end

	#ping the API for the product JSON
	DATA = File.read('/home/urbil/Escritorio/rubyProiektua/WebAplikazioa/data/erabiltzailea.json')['pertsonak']
	# locations offered by Fomotograph

	# initialize a Product object using a data hash
	def initialize(person_data = {})
	  @id = person_data['id']
	  @Izena = person_data['Izena']
	  @Abizena = person_data['Abizena']
	  @Korreoa = person_data['Korreoa']
	  @Hiria = person_data['Hiria']
	  @ErabIzena = person_data['ErabIzena']
	  @Pasahitza = person_data['Pasahitza']
	end
	
	# Pertsona objektuen Array-a itzuli
	def self.all
	  DATA.map {|pertsona| new(pertsona)}
	end
	
	#id-a daukan pertsona itzuli
	def self.find(id)
	  self.all.select{|pertsona| pertsona.id == id}.first
	end
end
