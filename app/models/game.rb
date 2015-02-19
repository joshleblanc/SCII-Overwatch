class Game
	include DataMapper::Resource

	property :id, Serial
	property :map, String, key: true
	property :time, String, key: true
	property :winner, String
	property :evidence, Text
	property :uploaded_at, DateTime

	belongs_to :player

	def self.recent
		all(limit: 100, order: [:id.desc])
	end

end