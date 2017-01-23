class Player
	include DataMapper::Resource

	property :id, Integer, key: true
	property :race, String
	property :server, String
	property :guilty_count, Integer, default: 0
	property :innocent_count, Integer, default: 0

	has n, :games, through: :gameplayers
  has n, :names

  def self.recently_accused
    all.sort do |x, y|
      y.last_game <=> x.last_game
    end
  end

  def last_game
    games.last
  end
  
  def bnet_url
    "http://#{self.server}.battle.net/sc2/en/profile/#{self.id}/1/#{self.name.split('<sp/>').last}/"
  end

  def name
    names.last.value
  end

  def css_class
    if is_guilty? 
      'danger'
    elsif is_innocent?
      'success'
    else
      'warning'
    end
  end

	def is_guilty?
		self.guilty_count > self.innocent_count
	end

	def is_innocent?
		self.innocent_count > self.guilty_count
	end

	def self.search(player)
		all.names(:value.like => "%#{player}%").player
	end

	def last_game
		self.games.first(order: [:uploaded_at.desc])
	end

end
