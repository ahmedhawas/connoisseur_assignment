require "JSON"
require "open-uri"



class HtmlGenerator

	attr_accessor :product_names, :product_prices, :categories, :image_urls

	def initialize(product_names, product_prices, categories, image_urls)
		@product_names = product_names
		@product_prices = product_prices
		@categories= categories
		@image_urls = image_urls
	end

	
	def index
		
		puts "HtmlGenerator: index"
		raw_response = open("http://lcboapi.com/products").read
		# Parse JSON­formatted text into a Ruby Hash
		parsed_response = JSON.parse(raw_response)
		# Return the actual result data from the response, ignoring metadata
		final_page =parsed_response["pager"]["final_page"]


		for i in 1..20 #it takes too long to run all pages available so take only subset of pages
			raw_response = open("http://lcboapi.com/products?page=#{i}").read
			parsed_response = JSON.parse(raw_response)
			for j in 0..parsed_response["result"].length-1
				product = parsed_response["result"][j]["name"]
				price = parsed_response["result"][j]["regular_price_in_cents"]
				category = parsed_response["result"][j]["primary_category"]
				image_url = parsed_response["result"][j]["image_url"]

				@product_names << product
				@product_prices << price
				@categories << category
				@image_urls << image_url
			end
		end

	end

	def show(product_id)
		puts "HtmlGenerator: show #{product_id}"

		raw_response = open("http://lcboapi.com/products/#{product_id}").read
		parsed_response = JSON.parse(raw_response)

		return parsed_response

		# write the same as the index method but passing a product_id inend
	end




end