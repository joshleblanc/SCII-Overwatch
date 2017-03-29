require_relative "base.rb"

module Site
  module Routes
    class Submit < Base

      get '/submit/?' do
        render_page :submit
      end

      get '/submit/:game_id' do
        @game = Game.get(params[:game_id])
        redirect "list/recent?err=no_game" if @game.nil?
        render_page :submit
      end

      post '/submit/:game_id' do
        game_player = GamePlayer.first(game_id: params[:game_id], player_id: params[:name])
        if game_player.is_accused?
          redirect "#{game_player.view_url}?err=already_submitted"
        else
          game_player.accuse! params[:evidence]
        end
        Voter.create(ip: request.ip, game: game_player.game)
        redirect game_player.view_url
      end

      post '/submit/?' do
        begin
          file = params[:file][:tempfile]
          replay = Sc2RepParser::Sc2Replay.new(file)
          p replay
          game_players = replay.players.map do |player|
            p player
            game_player = GamePlayer.first_or_create({
              player: Player.first({ id: player.id[:real_id] }),
              game: Game.first({ map: replay.map, date: replay.date })
            }, {
              player: Player.first_or_create({ id: player.id[:real_id] },
                id: player.id[:real_id],
                race: player.race,
                server: replay.server,
                names: [Name.new(value: player.name)]
              ),
              game: Game.first_or_create({
                map: replay.map,
                date: replay.date
              }, {
                map: replay.map,
                date: replay.date,
                uploaded_at: Time.now
              }),
              winner: player.outcome == 1
            })
            unless game_player.player.names.map(&:value).include? player.name
              game_player.player.names << Name.new(value: player.name)
              game_player.player.save
            end
            game_player
          end
          p "Copy file"
          FileUtils.cp(file.path, "./files/#{game_players.first.game.id}.SC2Replay")
        rescue
          p $!.message
          return "/list/recent?err=invalid_version"
        end
        "/submit/#{game_players.first.game.id}"
      end
    end
  end
end
