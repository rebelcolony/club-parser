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

		def self.fetch_all
			year = Time.now.strftime("%Y")
			month = Time.now.strftime("%m")
			self.fetch_for_month(year, month)
		end

		def to_hash
			result = { pacha: { events: [] } }
			result[:pacha][:events] = @events.map(&:to_hash)
			result
		end

		def self.fetch_for_this_month
			year = Time.now.strftime("%Y")
			month = Time.now.strftime("%m")
			self.fetch_for_month(year, month)
		end

		def self.fetch_for_month(year, month)
			url = "http://www.pacha.com/calendar/#{year}-#{month}"
			PachaParser.new(open(url)).to_hash
		end

		private
		def parse
			@doc.css('.has-events').each do |ticket|
				ticket.css('.view-item').each do |node|
					event = Event.new
					event.date = parse_date(ticket)
					event.title = parse_title(node)
					event.places = parse_places(node)
					@events << event
				end
			end
		end

		def parse_date(node)
			Date.parse(node['id'][-10, 10])
		end

		def parse_title(node)
			node.at_css('.node-title').text.strip
		end

		def parse_places(node)
			places = []
			places << Place.new(node.at_css('.node-title').text.strip, node.at_css('.node-data-field-artists-field-artists-value').text)
			places
		end
	end
end