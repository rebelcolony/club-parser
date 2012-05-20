require "open-uri"
require "nokogiri"
require "club-parser/version"

module ClubParser
  autoload :AmnesiaParser, File.expand_path('club-parser/amnesia.rb', File.dirname(__FILE__))
  autoload :PachaParser, File.expand_path('club-parser/pacha.rb', File.dirname(__FILE__))
  autoload :SpaceParser, File.expand_path('club-parser/space.rb', File.dirname(__FILE__))
  autoload :EsparadisParser, File.expand_path('club-parser/esparadis.rb', File.dirname(__FILE__))
  autoload :Event, File.expand_path('club-parser/event.rb', File.dirname(__FILE__))

  def self.fetch_all_from(club)
  	case club
  	when :amnesia then ClubParser::AmnesiaParser.fetch_all
  	when :pacha then ClubParser::PachaParser.fetch_all
    when :space then ClubParser::SpaceParser.fetch_all
    when :esparadis then ClubParser::EsparadisParser.fetch_all
  	else
  		{}
  	end
  end
end
