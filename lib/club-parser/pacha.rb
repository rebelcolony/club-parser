module ClubParser
	class PachaParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end


		def self.parse(text)
			PachaParser.new(text).events
		end

		def to_s
		end

		private
		def parse
			@doc.css('.has_events').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				event.title = parse_title(ticket)
				event.places = parse_places(ticket)
				@events << event
			end
		end

		def parse_date(node)
			Date.parse(node['id'])
		end

		def parse_title(node)
			node.at_css('.node-title').text
		end

		def parse_places(node)
			places = []
			places << Place.new(node.at_css('.node-title').text, node.at_css('.node-data-field-artists-field-artists-value').text)
			places
		end
	end
end