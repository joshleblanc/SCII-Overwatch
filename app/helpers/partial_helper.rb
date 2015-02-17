module Site
	module Helpers
		def render_partial(template)
  		haml :"partials/#{template}", :partial => false
  	end

		def script(file)
			@file = file
			render_partial(:script_tag)
		end

		def css(file)
			@file = file
			render_partial(:css_tag)
		end
	end
end
