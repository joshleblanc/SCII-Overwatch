class GamePlayer
  include DataMapper::Resource

  property :is_accused, Boolean
  property :winner, Boolean
  property :evidence, Text
  property :clan, String
  property :race, String
  property :mmr, Integer
  property :division, String
  property :server_rank, Integer
  property :global_rank, Integer
  property :apm, Integer
  property :team, Integer
  property :color, String
  property :guilty_count, Integer, default: 0
  property :innocent_count, Integer, default: 0

  belongs_to :game, key: true
  belongs_to :player, key: true

  def self.create_from_json(replay_info)
    game = Game.create_from_json(replay_info)
    replay_info['players'].map do |data|
      player = Player.first_or_create({ id: data['players_id'] }, {
          id: data['players_id'],
          bnet_url: data['player']['battle_net_url'],
          server: data['player']['battle_net_url'].split('.')[0].split('//')[1],
          bnet_id: data['player']['character_link_id'],
          names: [Name.new(value: data['players_name'])]
      })
      unless player.names.map(&:value).include? data['player']['players_name']
        player.names << Name.new(value: data['player']['players_name'])
        player.save
      end
      create(player: player,
             game: game,
             winner: data['winner'] == 1,
             clan: data['clan'],
             race: data['race'],
             mmr: data['mmr'],
             division: data['division'],
             server_rank: data['server_rank'],
             global_rank: data['global_rank'],
             apm: data['apm'],
             team: data['team'],
             color: data['color'])
    end
  end

  def accuse!(evid)
    self.is_accused = true
    self.evidence = evid
    save
  end

  def self.all_accused
    all(is_accused: true).reverse
  end

  def view_url
    "/players/#{player.id}/game/#{game.id}/"
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
end
