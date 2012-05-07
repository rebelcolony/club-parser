module ClubParser
	class Place
		attr_accessor :title, :lineup

		def initialize(title, lineup)
			@title = title
			@lineup = lineup
		end
	end

	class Event
		attr_accessor :date, :title, :places

		def initialize
			@places = []
		end
	end
end