require "JSON"
require "open-uri"
require "erb"


class HtmlGenerator
	
	def index
		template = File.read('layout.html.erb')
		
		puts "HtmlGenerator: index"
		raw_response = open("http://lcboapi.com/products").read
		# Parse JSON­formatted text into a Ruby Hash
		parsed_response = JSON.parse(raw_response)
		# Return the actual result data from the response, ignoring metadata
		final_page =parsed_response["pager"]["final_page"]

		@product_names = []
		@product_prices = []
		@categories= []
		@image_urls = []

		for i in 1..20 #it takes too long to run all pages available so take only subset of pages
			raw_response = open("http://lcboapi.com/products?page=#{i}").read
			parsed_response = JSON.parse(raw_response)
			for j in 0..parsed_response["result"].length-1
				product = parsed_response["result"][j]["name"]
				price = parsed_response["result"][j]["regular_price_in_cents"]
				category = parsed_response["result"][j]["primary_category"]
				image_url = parsed_response["result"][j]["image_url"]
				@product_names.push(product)
				@product_prices.push(price)
				@categories.push(category)
				@image_urls.push(image_url)
			end
		end

		erb_result = ERB.new( template ).result
		File.open('lcbo.html','w') {|file| file.write(erb_result)}

	end

	def show(product_id)
	# write the same as the index method but passing a product_id inend
	end




end