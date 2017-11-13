class Player
	include DataMapper::Resource

	property :id, Integer, key: true
  property :bnet_url, String, length: 200
  property :server, String, length: 3
  property :bnet_id, Integer

	has n, :games, through: :gameplayers
  has n, :names

  def self.recently_accused
    players = GamePlayer.all.select { |gp| gp.is_accused? }.map(&:player).uniq
    players.sort do |x, y|
      y.last_game <=> x.last_game
    end
  end

  def total_innocent_votes
    gameplayers.inject(0) { |s, a| s + a.innocent_count }
  end

  def total_guilty_votes
    gameplayers.inject(0) { |s, a| s + a.guilty_count}
  end

  def num_accused
    accused_games.count
  end

  def accused_games
    gameplayers.all(is_accused: true).game
  end

  def name
    names.last.value
  end


	def self.search(player)
		all.names(:value.like => "%#{player}%").player
	end

	def last_game
		self.accused_games.first(order: [:uploaded_at.desc])
	end

end
