require './html_generator.rb'
require "erb"

template = File.read('layout.html.erb')


if ARGV.empty?
	puts "Usage: ruby router.rb [action]"
else
	action = ARGV[0]
	@product_names =Array.new
	@product_prices =Array.new
	@categories =Array.new
	@image_urls =Array.new
	generator = HtmlGenerator.new(@product_names, @product_prices, @categories, @image_urls)
	if (action == "index")
		@index_called = true # a variable used so that erb file knows what to print, the show values or the index values
		@show_called=false 
		generator.index
	elsif (action == "show")
		@show_called=true 
		@index_called = false
		response = generator.show(ARGV[1].to_i)
		@name = response["result"]["name"]
		@price = response["result"]["regular_price_in_cents"]
		@category = response["result"]["primary_category"]
		@image_url = response["result"]["image_url"]
	else
		puts "Unknown action #{action}. Use index or show."
	end
end


erb_result = ERB.new( template ).result
File.open('lcbo.html','w') {|file| file.write(erb_result)}
