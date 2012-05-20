# encoding: utf-8
module ClubParser
	class EsparadisParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end

		def to_hash
			result = { esparadis: { events: [] } }
			result[:esparadis][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			EsparadisParser.new(text).to_hash
		end

		def self.fetch_all
			base_url = "http://www.esparadis.com/en/tickets/1-tickets/view-all-products.html"
			page = open base_url
			result = { esparadis: { events: [] } }
			result[:esparadis][:events] += self.parse(page)[:esparadis][:events]
			while node = Nokogiri::HTML(page).at('a[title="Next"]') do
				page = open node[:href]
				result[:esparadis][:event] += self.parse(page)[:esparadis][:event]
			end
			result
		end

		protected
		def parse
			@doc.css('.vmj-bro-cont').each do |ticket|
				event = Event.new
				event.date = parse_date(ticket)
				event.places = [Place.new('lol', 'ol')]
				event.price = Price.new
				event.title = parse_title(ticket)
				# event.places = parse_places(ticket)
				event.price = parse_price(ticket)
				event.url = parse_url(ticket)
				parse_description(event)
				@events << event
			end
		end

		def parse_description(event)
			data = open event.url
			desc = Nokogiri::HTML(data)
			event.flyer = desc.at_css('.vmj_thumbnail span img')[:src]
			lineup = desc.at_css('#sectionb').text.sub('Product Description', '').sub('Descripción de producto', '')
			event.places = [Place.new(event.title, lineup)]
		end

		def parse_date(node)
			Date.parse(node.at_css('.vmj_featured_name').text)
		end

		def parse_title(node)
			node.at_css('.vmj_featured_name').text.gsub(/[\n\t]/, '').sub(" - No Queue", "").gsub(/\A\s+/, '').gsub(/\s+\Z/, '').squeeze[11..-1]
		end

		def parse_price(node)
			if node.at_css('.vmj_featured_price')
				raw = node.at_css('.vmj_featured_price').text.gsub(/[^\d\.]/, "")
				Price.new(raw)			
			else
				Price.new
			end
		end

		def parse_url(node)
			"http://www.esparadis.com" + node.css('.vmj_featured_name a').last[:href]
		end

		def parse_flyer(node)
			url = "http://www.amnesia.es" + node.css('a').last[:href]
			doc = Nokogiri::HTML(open(url))
			"http://www.amnesia.es" + doc.at_css('#partyimg')[:src][2..-1]
		end

		def parse_place_title(node)
			node.at_css('.place.movement').text
		end

		def parse_place_lineup(node)
			node.at_css('.lineup').text
		end
	end
end