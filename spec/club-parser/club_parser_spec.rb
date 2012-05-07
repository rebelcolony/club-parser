require 'spec_helper'

describe ClubParser do
	before(:all) do
		@sample = load_fixture("amnesia")
	end
	
	it "Returns array of events when parsing is done" do
		result = ClubParser::AmnesiaParser.parse(@sample)
		result.length.should eq(3)	
	end

	describe ClubParser::AmnesiaParser do
		before(:all) do
			@parser = ClubParser::AmnesiaParser.new(@sample)
		end
		it "Saves text in a variable" do
			@parser.text.should eq(@sample)
		end

		it "Parsers an array of events" do
			@parser.events.class.should eq(Array)
			@parser.events.length.should eq(3)
			@parser.events[0].class.should eq(ClubParser::Event)
		end

		it "Parses event date" do
			@parser.events.first.date.should eq(Date.new(2012, 7, 2))
		end

		it "Parses event title" do
			@parser.events.first.title.should eq("COCOON PRESENTS DESOLAT")
		end

		it "Parses event places" do
			@parser.events[0].places.class.should eq(Array)
			@parser.events[0].places[0].title.should eq("MAIN ROOM")
			@parser.events[0].places[1].title.should eq("TERRACE")
		end

		it "Parses event lineup" do
			@parser.events[0].places[0].lineup.should match("Voorn")
		end
	end
end