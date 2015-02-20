class Voter
	include DataMapper::Resource

	property :id, Serial
	property :ip, String

	belongs_to :game

end