require 'rubygems'
require 'nokogiri'
require 'open-uri'

class StartScrap
	def initialize
		@crypto_names = []
		@crypto_prices = []
		@crypto_names_prices = []

		Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/")).css('.currency-name-container').each do |crypto_name|
			@crypto_names << crypto_name.text														# Récupère les noms des cryptos et les stocke dans un array
		end

		Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/")).css('.price').each do |crypto_price|
			@crypto_prices << crypto_price.text.gsub("$", "").gsub(",", ".").gsub("?", "").to_f		# Récupère les cours des cryptos, les convertit en float et les stocke dans un array
		end
	end
	
	def perform
		@crypto_names.each_with_index do |crypto, i|													# Combine les deux arrays en un hash
			hash_temp = {}
			hash_temp["name"] = @crypto_names[i]
			hash_temp["price"] = @crypto_prices[i]
			@crypto_names_prices << hash_temp
		end

		@crypto_names_prices.each.with_index do |item, i|											# Parcours le hash et remplace les valeurs nulles par "?"
			if @crypto_names_prices[i]["price"] == 0
				@crypto_names_prices[i]["price"] = "?"
			end
		end

		save
	end

	def save
		@crypto_names_prices.each do |value|
            Crypto.create(name: value["name"], price: value["price"])
        end
	end
end