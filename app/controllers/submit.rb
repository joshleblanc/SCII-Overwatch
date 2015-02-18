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
				p params
				player = replay.players.select { |pl| pl.name.gsub('<sp/>', '').gsub(' ', '') == params[:name] }.first
				p player
				if player.nil? then
					redirect to '/submit?error=player_not_found'
				end
				player = Player.first_or_create(
						id: player.id,
						race: player.actual_race,
						name: player.name.gsub('<sp/>', '').gsub(' ', ''),
				    server: params[:server]
				)

				game = Game.first_or_create(
					player: player,
				  map: replay.game.map,
				  time: replay.game.time,
				)
				game.uploaded_at = Time.now
				game.save
				cookies["#{game.id}vote"] = true
				FileUtils.cp(file.path, "./files/#{game.id}.SC2Replay")
				redirect to "/game/#{game.id}"
			end

		end
	end
end