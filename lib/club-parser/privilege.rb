# encoding: utf-8
module ClubParser
	class PrivilegeParser
		attr_reader :text, :events

		def initialize(text)
			@text = text
			@doc = Nokogiri::HTML(@text)
			@events = []
			parse
		end

		def to_hash
			result = { privilege: { events: [] } }
			result[:privilege][:events] = @events.map(&:to_hash)
			result
		end


		def self.parse(text)
			PrivilegeParser.new(text).to_hash
		end

		def self.fetch_all
			month = DateTime.now.strftime("%m")
			url = "http://www.privilegeibiza.com/calendar/month/#{month}/index.html"
			results = { privilege: { events: [] } }
			4.times do
				cal = Nokogiri::HTML(open(url, 'User-Agent' => 'club_parser'))
				cal.css('.termine_entry_active').each do |event|
					path = event.at_css('a')[:href]
					results[:privilege][:events] += self.parse(open(path, 'User-Agent' => 'club_parser'))[:privilege][:events]
				end
				url = cal.at_css('.cal_next a')[:href]
			end
			results
		end

		protected
		def parse
			event = Event.new
			event.date = parse_date(@doc)
			event.title = parse_title(@doc)
			event.places = parse_places(@doc)
			event.price = parse_price(@doc)
			event.url = parse_url(@doc)
			event.flyer = parse_flyer(@doc)
			@events << event
		end

		def parse_date(node)
			Date.parse(node.at_css('.news_home_headline').text)
		end

		def parse_title(node)
			node.at_css('.newsblog_txt_wrap h1').text
		end

		def parse_price(node)
			Price.new
		end

		def parse_url(node)
			node.at_css('.events_header_wrapper a.events2')[:href]
		end

		def parse_flyer(node)
			if node.at('.newsblog_txt_wrap img')
				"http://www.privilegeibiza.com/" + node.at_css('.newsblog_txt_wrap img')[:src]
			end
		end

		def parse_places(node)
			title = node.at_css('.newsblog_txt_wrap h1').text
			lineup = node.at_css('.newsblog_txt_wrap').text.sub(title, '')
			[Place.new(title, lineup)]
		end
	end
end