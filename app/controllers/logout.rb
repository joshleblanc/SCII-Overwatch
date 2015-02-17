module Site
  module Routes
    class Logout < Base
      get '/logout/?' do
        unless session['user'].nil?
          logout
        end
        redirect to "login"
      end
    end
  end
end
