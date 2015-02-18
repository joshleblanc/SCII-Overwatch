require_relative 'base.rb'

module Site
	module Routes
		class Search < Base
			post '/search' do
				@players = Player.all(:name.like => "%#{params[:player_name]}%")

				render_page :search
			end
		end
	end
end