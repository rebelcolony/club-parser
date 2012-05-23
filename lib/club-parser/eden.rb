# encoding: utf-8
module ClubParser
	class EdenParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end

		def to_hash
			result = { eden: { events: [] } }
			result[:eden][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			EdenParser.new(text).to_hash
		end

		def self.fetch_all
			results = { eden: { events: [] } }
			days = %w{monday tuesday wednesday thursday friday saturday sunday}
			days.each do |day|
				url = "http://www.edenibiza.com/category/events/event-#{day}/"
				results[:eden][:events] += self.parse(open(url))[:eden][:events]
			end
			results
		end

		protected
		def parse
			@doc.css('.widget_listcategorypostswidget li').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				url = ticket.at_css('a')[:href]
				@ticket = Nokogiri::HTML(open(url))
				event.title = parse_title
				event.places = parse_places
				event.price = parse_price
				event.url = url
				event.flyer = parse_flyer
				@events << event
			end
		end

		def parse_date(node)
			Date.parse(node.text)
		end

		def parse_title
			@ticket.at_css('.postwrap h2').text if @ticket.at_css('.postwrap h2')
		end

		def parse_price
			Price.new
		end

		def parse_flyer
			if @ticket.at_css('.textwidget img')
				"http://www.edenibiza.com" + @ticket.at_css('.textwidget img')[:src]
			else
				''
			end
		end

		def parse_places
			title = parse_title
			lineup = @ticket.at_css('.postwrap h1:not(.title)').text if @ticket.at_css('.postwrap h1:not(.title)')
			[Place.new(title, lineup)]
		end
	end
end