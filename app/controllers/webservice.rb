require 'json'
module Site
  module Routes
    class Webservice < Base
      get '/webservice/players' do
        JSON.generate Player.all
      end
    end
  end
end
