class Player
	include DataMapper::Resource

	property :id, Integer, key: true
	property :race, String
	property :name, String
	property :server, String
	property :guilty_count, Integer, default: 0
	property :innocent_count, Integer, default: 0

	has n, :games

	def is_guilty?
		p self.guilty_count, self.innocent_count
		self.guilty_count > self.innocent_count
	end

	def is_innocent?
		self.innocent_count > self.guilty_count
	end

	def self.search(player)
		all(:name.like => "%#{player}%")
	end

	def last_game
		self.games.first(order: [:uploaded_at.desc])
	end

end