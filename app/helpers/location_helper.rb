module Site
	module Helpers
		def at_most_recent?
			request.path_info.downcase.include? "/list/recent"
		end

		def at_suspicious?
			request.path_info.downcase.include? "/list/suspicious"
		end

		def at_guilty?
			request.path_info.downcase.include? "/list/guilty"
		end

		def at_submit?
			request.path_info.downcase.include? "/submit"
		end
	end
end