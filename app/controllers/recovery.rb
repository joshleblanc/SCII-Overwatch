require_relative "base.rb"

module Site
  module Routes
    class Recovery < Base
      get '/recovery/?' do
        render_page :recovery
      end

      post '/recovery/?' do
        email = params[:email]
        if email.nil?
          redirect to '/recovery?reason=noemail'
        elsif email == params[:confirmemail]
          time_now = encrypt(Time.now.to_f.to_s)
          temp_pass = time_now[6..12]
          set_recovery(time_now, params[:email])
          send_email(email, temp_pass)
          change_password(time_now, encrypt(temp_pass))
          redirect to '/login?reason=passwordrecoverysuccessful'
        else
          redirect to '/recovery?reason=nomatch'
        end
      end
    end
  end
end
