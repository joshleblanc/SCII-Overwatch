class Voter
	include DataMapper::Resource

	property :ip, String, key: true

	belongs_to :game

end