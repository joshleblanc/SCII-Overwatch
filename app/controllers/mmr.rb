require_relative 'base.rb'
module Site
	module Routes
		class Mmr < Base
			get '/mmr-tool/?' do
				render_page :mmr
			end

			post '/mmr-tool/hots/?' do
				append_to_file("data_hots_i.txt", params_data)
			end
			post '/mmr-tool/wol/?' do
				append_to_file("data_wol_i.txt", params_data)
			end

			private
				def append_to_file(name, data)
					open("#{Dir.pwd}/public/mmr/gamedata/#{name}", 'a') { |f| f << data}
				end

				def params_data
					params.to_a[0][0]
				end
		end
	end
end