require_relative 'base.rb'

module Site
	module Routes
		class Games < Base
			get '/game/download/:id' do
				send_file "./files/#{params[:id]}.SC2Replay", filename: "#{params[:id]}.SC2Replay", type: 'Application/octet-stream'
			end
		end
	end
end
