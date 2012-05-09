# encoding: utf-8
require 'spec_helper'

describe ClubParser do
	before(:all) do
		@sample = load_fixture("pacha")
	end
	
	it "Returns array of events when parsing is done" do
		result = ClubParser::PachaParser.parse(@sample)
		result.length.should eq(13)	
	end

	describe ClubParser::AmnesiaParser do
		before(:all) do
			@parser = ClubParser::PachaParser.new(@sample)
		end
		it "Saves text in a variable" do
			@parser.text.should eq(@sample)
		end

		it "Parsers an array of events" do
			@parser.events.class.should eq(Array)
			@parser.events.length.should eq(13)
			@parser.events[0].class.should eq(ClubParser::Event)
		end

		it "Parses event date" do
			@parser.events[1].date.should eq(Date.new(2012, 4, 5))
		end

		it "Parses event title" do
			@parser.events.last.title.should eq("Abierto")
		end

		it "Parses event places" do
			@parser.events[0].places.class.should eq(Array)
			@parser.events[0].places[0].title.should eq("Ibiza White Experience")
		end

		it "Parses event lineup" do
			@parser.events[0].places[0].lineup.should match("Nuñez")
		end
	end
end