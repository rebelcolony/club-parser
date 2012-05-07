require 'club-parser'

def load_fixture(fixture)
	path = File.expand_path("fixtures/#{fixture}.html", File.dirname(__FILE__))
	file = File.open(path, "r")
	file.read
end