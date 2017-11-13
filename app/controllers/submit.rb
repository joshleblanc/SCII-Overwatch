require_relative 'base.rb'

module Site
  module Routes
    class Submit < Base
      get '/submit/status/:queue_id' do
        queue_id = params[:queue_id]
        if request.websocket?
          request.websocket do |ws|
            ws.onopen do
              settings.sockets[queue_id] = ws
            end

            ws.onclose do
              settings.sockets.delete(queue_id)
            end
          end
        end
      end

      get '/submit/?' do
        render_page :submit
      end

      get '/submit/:game_id' do
        @game = Game.get(params[:game_id])
        redirect 'list/recent?err=no_game' if @game.nil?
        render_page :submit
      end

      post '/submit/:game_id' do
        game_player = GamePlayer.first(game_id: params[:game_id], player_id: params[:name])
        game_player.accuse! params[:evidence]
        Voter.create(ip: request.ip, game: game_player.game)
        redirect game_player.view_url
      end

      post '/submit/?' do
        file = params[:file][:tempfile]
        client = Sc2replaystats::Client.new(ENV['sc2replaystats_auth'], ENV['sc2replaystats_hash'])
        replay = Sc2replaystats::Replay.new(client)
        resp = replay.upload(file)
        queue_id = resp['replay_queue_id']
        EM.defer do
          10.times do
            socket = settings.sockets[queue_id]

            upload_status = replay.upload_status(queue_id)
            msg = JSON.generate(upload_status)
            if socket && upload_status['error']
              socket.send(msg)
              break
            elsif upload_status['replay_id']
              replay_info = replay.replay_info(upload_status['replay_id'], :players)
              GamePlayer.create_from_json(replay_info)
              socket.send(msg) if socket
              break
            elsif socket
              socket.send(msg)
            end

            sleep 1
          end
        end
        queue_id
      end
    end
  end
end
