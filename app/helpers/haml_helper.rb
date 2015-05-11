module Site
  module Helpers
    def render_page(temp, layout = true)
      haml :"pages/#{temp}", layout: layout
    end
  end
end
