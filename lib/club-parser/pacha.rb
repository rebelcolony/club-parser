module ClubParser
	class PachaParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end


		def to_hash
			result = { pacha: { events: [] } }
			result[:pacha][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			PachaParser.new(text).to_hash
		end

		def self.fetch_all(from = 23, to = 39)
			results = { pacha: { events: [] } }
			results[:pacha][:events] += self.parse_month[:pacha][:events]
			results
		end

		def self.parse_month(month = nil, year = nil)
			year = Time.now.strftime("%Y") if year.nil?
			month = Time.now.strftime("%m") if month.nil?
			self.parse open("http://www.pacha.com/calendar/#{year}-#{month}")
		end

		protected
		def parse
			@doc.css('.has-events').each do |ticket|
				ticket.css('.view-item').each do |node|
					event = Event.new
					event.date = parse_date(ticket)
					event.title = parse_title(node)
					event.places = parse_places(node)
					event.url = parse_url(node)
					event.flyer = parse_flyer(node)
					event.price = Price.new
					@events << event
				end
			end
		end

		def parse_date(node)
			Date.parse(node['id'][-10, 10])
		end

		def parse_url(node)
			node.at_css('a')[:href]
		end

		def parse_flyer(node)
			url = node.at_css('a')[:href]
			doc = Nokogiri::HTML open('http://www.pacha.com/' + url)
			doc.at_css('img.imagecache')[:src]
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