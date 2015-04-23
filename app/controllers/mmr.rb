require_relative 'base.rb'
module Site
	module Routes
		class Mmr < Base
			get '/mmr-tool' do
				render_page :mmr
			end
		end
	end
end