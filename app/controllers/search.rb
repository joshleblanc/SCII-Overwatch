require_relative 'base.rb'

module Site
	module Routes
		class Search < Base
			post '/search/?' do
				redirect to "/search/#{params[:player_search]}"
			end

			get '/search/:name/?' do
				@players = Player.search(params[:name])

				render_page :search
			end

			get '/search/:id/games/?' do
        @games = Player.get(params[:id]).games
				render_page :game_list
			end
		end
	end
end
