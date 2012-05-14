module ClubParser
	class SpaceParser
		attr_reader :text, :events, :month, :price_url

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end

		def to_hash
			result = { space: { events: [] } }
			result[:space][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			SpaceParser.new(text).to_hash
		end

		def self.fetch_all
			@url = "http://shop.spaceibiza.com/index.php?dispatch=categories.view&category_id=165&next_time=#{Time.now.to_i}"
			results = { space: { events: [] } }
			results[:space][:events] = self.parse(open(@url))[:space][:events]
			results
		end

		def parse
			@month = @doc.at_css('td.currentmonth').text
			@doc.css('.weekdayclr').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				event.title = parse_title(ticket)
				if event.title
					url = "http://shop.spaceibiza.com/" + ticket.at_css('.cm-ajax')[:href]
					@description = Nokogiri::HTML(open(url))
					event.places = parse_places(ticket)
					event.price = parse_price(ticket)
					event.url = @url
					event.flyer = parse_flyer(ticket)
					@events << event
				end
			end
			self
		end

		def parse_date(node)
			# Time.now.to_datetime
			Date.parse(node.at_css('.caldaydigits').text + " " + @month)
		end

		def parse_title(node)
			node.css('.eventstyle div').last.text if node.at_css('.eventstyle div')
		end

		def parse_price(node)
			price = @description.at_css('span.price').text.match(/\d+\.\d+/)[0].to_i
			Price.new price
		end

		def parse_flyer(node)
			"http://shop.spaceibiza.com" + @description.at_css('.view-larger-image')[:href]
		end

		def parse_places(node)
			places = []
			title = @description.at_css('.mainbox-title').text
			lineup = @description.at_css('.wysiwyg-content p').text
			places << Place.new(title, lineup)
			places
		end
	end
end