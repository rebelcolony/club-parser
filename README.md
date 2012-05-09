ClubParser
==========

This is a custom gem that parses information about clubbing events from different sites. Currently supported:

  * [Amnesia](http://www.amnesia.es)

Installation
============

Add this line to your application's Gemfile:

    gem 'club-parser', git: "git@github.com:ivliaspiration/club-parser.git"

And then execute:

    $ bundle

Usage
=====

The most important method is `ClubParser.fetch_all_from` which takes one of the following symbols:

* `:amnesia`

It will return a hash like this:

	{
		:amnesia =>
			:events => [
				{ ... }
			]
	}

The hash is compatible with Rails defaults for ActiveRecord, so the complete example is:
	
	data = ClubParser.fetch_all_from :amnesia
	data[:amnesia][:events].each do |event|
		Event.create!(event) # where Event is active record model
	end

### Expected ActiveRecord schema

ActiveRecord should conform to the following schema:

	create_table "events", :force => true do |t|
	    t.date     "date"
	    t.string   "title"
	    t.string   "url"
	    t.string   "flyer"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end

	  create_table "places", :force => true do |t|
	    t.integer  "event_id"
	    t.string   "title"
	    t.text     "lineup"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end

	  create_table "prices", :force => true do |t|
	    t.integer  "vip"
	    t.integer  "regular"
	    t.integer  "no_queue"
	    t.integer  "event_id"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end

In model classes, `Event` should `has_one :price` and `has_many :places`, and `Price` and `Place` should `belongs_to` `Event`.

Site-specific details
=====================

### Amnesia
Amnesia have two places for each event - a main room and a terrace - thus every events has many places. They differ by lineup. The first place in the hash will always be the main room, and the second place - the terrace.

Amensia's calendar is week-based, so we can fetch events by week. The events this week start at week 23 and end at week 39, and `ClubParser.fetch_all_from :amnesia` will parse them all. It will also fetch flyers for the events.

### Pacha
TODO

