require 'open-uri'
require 'nokogiri'
require "club-parser/version"

module ClubParser
  autoload :AmnesiaParser, File.expand_path('club-parser/amnesia.rb', File.dirname(__FILE__))
  autoload :PachaParser, File.expand_path('club-parser/pacha.rb', File.dirname(__FILE__))
  autoload :Event, File.expand_path('club-parser/event.rb', File.dirname(__FILE__))
end
