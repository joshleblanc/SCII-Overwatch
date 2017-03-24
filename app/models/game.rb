class Game
	include DataMapper::Resource

	property :id, Serial
	property :map, String, unique_index: true
	property :date, Integer, unique_index: true
	property :uploaded_at, DateTime

  has n, :players, through: :gameplayers
	has n, :voters

	def self.recent
		all(limit: 100, order: [:id.desc])
	end

  def winners
    self.gameplayers.select(&:winner?).map(&:player)
  end

end
