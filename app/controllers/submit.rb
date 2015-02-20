require_relative "base.rb"

module Site
	module Routes
		class Submit < Base

			get '/submit/?' do
				render_page :submit
			end

			post '/submit/?' do
				file = params[:replay][:tempfile]
				filename = params[:replay][:filename]
				replay = Tassadar::SC2::Replay.new(file)
				server = replay.details[:data][10].first[6...8]
				replay_player = replay.players.select { |pl| pl.name.gsub('<sp/>', '').gsub(' ', '').downcase == params[:name].gsub(' ', '').downcase }.first

				if replay_player.nil? then
					redirect to '/submit?error=player_not_found'
				end

				if params[:evidence].length <= 0
					redirect to '/submit?error=no_evidence'
				end

				player = Player.first_or_create(
						id: replay_player.id
				)
				player.race = replay_player.actual_race
				player.name = replay_player.name.gsub('<sp/>', '').gsub(' ', '')
				player.server = server

				game = Game.first_or_create(
					player: player,
				  map: replay.game.map,
				  time: replay.game.time,

				)
				game.evidence = params[:evidence]
				game.winner = replay.game.winner.name.gsub('<sp/>', '')
				game.uploaded_at = Time.now
				game.players = replay.players
				game.save

				Voter.create(ip: request.ip, game: game)
				FileUtils.cp(file.path, "./files/#{game.id}.SC2Replay")
				redirect to "/game/#{game.id}"
			end

		end
	end
end