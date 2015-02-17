module Site
  module Helpers
    def render_page(temp)
      haml :"pages/#{temp}"
    end
  end
end
