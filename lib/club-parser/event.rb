module ClubParser
	class Place
		attr_accessor :title, :lineup

		def initialize(title, lineup)
			@title = title
			@lineup = lineup

		end

		def to_hash
			result = {
				title: @title,
				lineup: @lineup,
			}
		end

		def to_s
			result = "#{@title}:\n"
			result << @lineup
		end
	end

	class Price
		attr_accessor :regular, :vip, :no_queue

		def initialize(regular = 0, vip = 0, no_queue = 0)
			@regular = regular
			@vip = vip
			@no_queue = no_queue
		end

		def to_hash
			result = {
				regular: @regular,
				vip: @vip,
				no_queue: @no_queue
			}
		end
	end

	class Event
		attr_accessor :date, :title, :places, :price, :url, :flyer

		def initialize
			@places = []
		end

		def to_hash
			result = {
					date: @date,
					title: @title,
					url: @url,
					flyer: @flyer
			}

			result[:price_attributes] = @price.to_hash

			result[:places_attributes] = @places.collect(&:to_hash)

			result
		end

		def to_s 
			result = ""
			result << "#{@title}: on #{@date.strftime("%d %B %Y")}:\n"
			result = places.map(&:to_s).join("\n")
		end
	end
end