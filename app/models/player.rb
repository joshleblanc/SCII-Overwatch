class Player
	include DataMapper::Resource

	property :id, Integer, key: true
	property :race, String
	property :name, String
	property :server, String
	property :guilty_count, Integer, default: 0
	property :innocent_count, Integer, default: 0
	property :hacker, Boolean, default: false

	has n, :games

end