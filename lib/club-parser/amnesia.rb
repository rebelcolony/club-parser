# encoding: utf-8
module ClubParser
	class AmnesiaParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end

		def to_hash
			result = { amnesia: { events: [] } }
			result[:amnesia][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			AmnesiaParser.new(text).to_hash
		end

		def self.fetch_all(from = 23, to = 39)
			url = "http://www.amnesia.es/webapp/events?week="
			results = { amnesia: { events: [] } }
			(from..to).each do |week|
				results[:amnesia][:events] += self.parse(open(url + week.to_s))[:amnesia][:events]
			end
			results
		end

		protected
		def parse
			@doc.css('.ticket').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				event.title = parse_title(ticket)
				event.places = parse_places(ticket)
				event.price = parse_price(ticket)
				event.url = parse_url(ticket)
				event.flyer = parse_flyer(ticket)
				@events << event
			end
		end

		def parse_date(node)
			Date.parse(node.at_css('.date').text)
		end

		def parse_title(node)
			node.at_css('.party.movement').text
		end

		def parse_price(node)
			if node.at_css('.price')
				raw = node.at_css('.price').text.gsub(/[^\d\/]/, "")
				prices = raw.split('/')
				regular = prices[0]
				if node.at_css('.price').inner_html.include?("display:none")
					price = Price.new(regular)
				else
					vip = prices[1]
					price = Price.new(regular, vip)
				end
				price
			else
				Price.new
			end
		end

		def parse_url(node)
			"http://www.amnesia.es" + node.css('a').last[:href].gsub('é', '')
		end

		def parse_flyer(node)
			url = "http://www.amnesia.es" + node.css('a').last[:href].gsub('é', '')
			doc = Nokogiri::HTML(open(url))
			"http://www.amnesia.es" + doc.at_css('#partyimg')[:src][2..-1]
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