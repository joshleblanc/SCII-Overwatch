class GamePlayer
  include DataMapper::Resource
  
  property :is_accused, Boolean
  property :winner, Boolean
  property :evidence, Text
  belongs_to :game, key: true
  belongs_to :player, key: true

  def accuse!(evid)
    self.is_accused = true
    self.evidence = evid
    self.save
  end

  def view_url
    "/players/#{self.player.id}/game/#{self.game.id}/"
  end

end
