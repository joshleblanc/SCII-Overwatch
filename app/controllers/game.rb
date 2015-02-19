require_relative 'base.rb'

module Site
	module Routes
		class Games < Base

			get '/game/:id' do
				p Game.all
				@game = Game.first(id: params[:id])
				@player = @game.player
				p @player.name
				p @game
				render_page :game
			end

			get '/game/:id/guilty' do
				render_page :guilty_evidence
				#unless cookies["#{params[:id]}vote"] then
				#	cookies["#{params[:id]}vote"] = true
				#	game = Game.first(id: params[:id])
				#``	player = game.player
				#	player.update(guilty_count: player.guilty_count + 1)
				#	redirect to request.referrer
				#end
			end

			get '/game/:id/innocent' do
				unless cookies["#{params[:id]}vote"] then
					cookies["#{params[:id]}vote"] = true
					game = Game.first(id: params[:id])
					player = game.player
					player.update(innocent_count: player.innocent_count + 1)
					redirect to request.referrer
				end
			end

			get '/game/download/:id' do
				send_file "./files/#{params[:id]}.SC2Replay", filename: "#{params[:id]}.SC2Replay", type: 'Application/octet-stream'
			end
		end
	end
end