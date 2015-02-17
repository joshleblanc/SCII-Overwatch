require_relative "base.rb"

module Site
  module Routes
    class Error < Base
      get '/error' do
        render_page :error
      end
    end
  end
end
