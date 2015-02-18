require_relative 'base.rb'

module Site
	module Routes
		class Search < Base
			post '/search' do
				redirect to "/search/#{params[:player_search]}"
			end

			get '/search/:name/?' do
				@players = Player.search(params[:name])

				render_page :search
			end
		end
	end
end