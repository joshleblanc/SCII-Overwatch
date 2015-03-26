require_relative 'base.rb'

module Site
	module Routes
		class Games < Base

			get '/game/:id' do
				p Game.all
				@game = Game.first(id: params[:id])
				@player = @game.player
				@can_vote = @game.voters.first(ip: request.ip).nil?
				p @game.voters
				p request.ip
				render_page :game
			end

			post '/game/:id' do
				game = Game.first(id: params[:id])
				if params[:winner_confirm].split.first != game.winner
					Voter.create(ip: request.ip, game: game)
					redirect to "#{request.referrer}?error=incorrect_winner"
				end

				if game.voters.first(ip: request.ip).nil?
					Voter.create(ip: request.ip, game: game)
					if params["verdict"] == "Guilty"
						game.player.update(guilty_count: game.player.guilty_count + 1)
					end
					if params["verdict"] == "Innocent"
						game.player.update(innocent_count: game.player.innocent_count + 1)
					end
				end
				redirect to '/list/recent'

			end

			get '/game/download/:id' do
				send_file "./files/#{params[:id]}.SC2Replay", filename: "#{params[:id]}.SC2Replay", type: 'Application/octet-stream'
			end
		end
	end
end