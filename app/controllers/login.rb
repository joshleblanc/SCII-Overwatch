require_relative "base.rb"

module Site
  module Routes
    class Login < Base

      get '/login/?' do
         render_page   :login
      end

      post '/login/?' do
        if params[:password].nil? || params[:password].length < 1
          redirect to '/login?reason=nopassword'
        end
        session['last_email'] = params[:email]
        authorize_login!(params[:email], encrypt(params[:password]))
        redirect to '/account'
      end
    end
  end
end
