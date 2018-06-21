require 'httparty'
require 'open-uri'
require 'nokogiri'
require 'rss'

class LinkExtractor
	def initialize(id)
	@links = []
	@id = id
	feed = "https://archive.org/advancedsearch.php?q=collection%3D%22#{@id}%22&fl%5B%5D=collection&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=10000&page=1&callback=callback&output=rss#raw"

	response = HTTParty.get feed # get the feed with HTTParty
	feed = RSS::Parser.parse response.body # put the feed content into the feed variable
	feed.items.each do |item|
          @links.push(item.link)
	end
	end
	def links
		@links
	end
	def id
		@id
	end
end

class Scraper
	attr_accessor :parse_page, :file_extension
	def initialize(url,extension)
	  @file_extension = extension
	  @collection_link_array = []
      	  @link_array = []
	  @zip_links = []
	  page =  Nokogiri::HTML(open(url))
	  links = page.css('a')
	  @hrefs = links.map {|link| link.attribute('href').to_s}
	  @hrefs.uniq!
	  add_ahrefs_to_link_array
	  filter_links_by_zip
	  @zip_links.each do |link|
		  puts "Adding: #{link}"
	    File.open('download_links.txt', 'a') { |f| f.write("#{link}\n") }
	  end
	end
	def hrefs
	       @hrefs	
	end
	def collection_ahrefs
		@collection_ahrefs
	end
	def file_extension
	  @file_extension
	end
	def collection
		@collection
	end
	def link_array
		@link_array
	end
	def zip_links
		@zip_links
	end
	def add_ahrefs_to_link_array
		@hrefs.each do |link|
			@link_array.push(link)
		end
	end
	def add_collection_ahrefs_to_collection_link_array
		@collection_ahrefs.each do |link|
			p link
			@collection_link_array.push(link)
		end
	end
	def collection_link_array
		@collection_link_array
	end
	def add_item_urls_to_file
	end
	def filter_links_by_zip
		link_array.each do |link|
			if link.match(@file_extension)
				@zip_links.push("https://archive.org#{link}")
			end
		end
	end
end

def main_application
	puts "Select function: \n 1: Scrape a collection and add the item urls to targets.txt"
 	puts "2: Download all files inside targets.txt (will be blank on first time use)"
  	choice = gets.chomp
  	case choice
  	when "1"
    		puts "Paste collection ID (e.g. bitsavers_mit):"
    		id = gets.chomp
    		extractor = LinkExtractor.new(id)
		IO.write("targets.txt", extractor.links.join("\n"))
		system('cat targets.txt')
		main_application
 	 when "2"
		puts "Which file extension should we scrape for? (ex: .txt, jp2.zip, .torrent)"
	  	file_extension = gets.chomp
    		targets = IO.readlines("targets.txt")
    		targets.each do |url_to_scrape|
      			scraper = Scraper.new(url_to_scrape.chomp,file_extension)
		end

	end
end

def download_prompt
  puts "Start download for scraped files? [Y/N]"
  choice = gets.chomp
  case choice.downcase
  when "y"
	  system('sudo wget -i download_links.txt -P ./downloads ')
  else
	  puts "Links to file download are in download_links.txt"
	  exit
end
end

#main_application
download_prompt
