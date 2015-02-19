require_relative "base.rb"
module Site
	module Routes
		class List < Base
			get '/list/recent' do
				@games = Game.recent
				#p Game.recent.players
				@players = Game.recent.map { |i| i.player }.uniq
				render_page :list
			end

			get '/list/guilty' do
				@players = Player.are_guilty

				render_page :hit_list
			end
		end
	end
end