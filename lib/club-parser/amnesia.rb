module ClubParser
	class AmnesiaParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end


		def self.parse(text)
			AmnesiaParser.new(text).events
		end

		private
		def parse
			@doc.css('.ticket').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				event.title = parse_title(ticket)
				event.places = parse_places(ticket)
				@events << event
			end
		end

		def parse_date(node)
			Date.parse(node.at_css('.date'))
		end

		def parse_title(node)
			node.at_css('.party.movement').text
		end

		def parse_places(node)
			places = []
			node.css('.info').each do |p|
				title = parse_place_title(p)
				lineup = parse_place_lineup(p)
				places << Place.new(title, lineup)
			end
			places
		end

		def parse_place_title(node)
			node.at_css('.place.movement').text
		end

		def parse_place_lineup(node)
			node.at_css('.lineup').text
		end
	end
end