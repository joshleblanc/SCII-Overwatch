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
				player = replay.players.select { |pl| pl.name.gsub('<sp/>', '').gsub(' ', '').downcase == params[:name].gsub(' ', '').downcase }.first
				p p
				if player.nil? then
					redirect to '/submit?error=player_not_found'
				end

				if params[:evidence].length <= 0
					redirect to '/submit?error=no_evidence'
				end

				player = Player.first_or_create(
						id: player.id,
						race: player.actual_race,
						name: player.name.gsub('<sp/>', '').gsub(' ', ''),
				    server: server,
				)

				game = Game.first_or_create(
					player: player,
				  map: replay.game.map,
				  time: replay.game.time,
				  winner: replay.game.winner,
				  evidence: params[:evidence],
				  uploaded_at: Time.now,
				  players: replay.players,
				  voters: []
				)
				cookies["#{game.id}vote"] = true
				FileUtils.cp(file.path, "./files/#{game.id}.SC2Replay")
				redirect to "/game/#{game.id}"
			end

		end
	end
end