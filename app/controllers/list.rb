require_relative "base.rb"
module Site
	module Routes
		class List < Base
			get '/list/recent' do
				@games = Game.recent

				render_page :list
			end

			get '/list/guilty' do
				@players = Player.are_guilty

				render_page :hit_list
			end
		end
	end
end