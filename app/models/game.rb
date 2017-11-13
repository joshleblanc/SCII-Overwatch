class Game
  include DataMapper::Resource

  property :id, Integer, key: true
  property :map, String
  property :date, DateTime
  property :uploaded_at, DateTime
  property :url, String
  property :format, String
  property :game_type, String
  property :season_id, Integer
  property :replay_version, String

  has n, :players, through: :gameplayers
  has n, :voters

  def self.recent
    all(limit: 100, order: [:id.desc])
  end

  def winners
    gameplayers.select(&:winner?).map(&:player)
   end

  def self.create_from_json(replay_info)
		p replay_info
    create(id: replay_info['replay_id'],
				   map: replay_info['map_name'],
           date: replay_info['replay_date'],
           url: replay_info['replay_url'],
           format: replay_info['format'],
           game_type: replay_info['game_type'],
           season_id: replay_info['seasons_id'],
           replay_version: replay_info['replay_version'])
  end
end
