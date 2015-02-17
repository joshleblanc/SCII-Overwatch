require_relative "base.rb"

module Site
  module Routes
    class Account < Base
      get '/account/?' do
        authorize!
        @user = session['user']
        render_page :account
      end

      get '/account/changepassword/?' do
        authorize!
        render_page :change_password
      end

      post '/account/changepassword/?' do
        if params[:newpassword] != params[:confirmpassword]
          redirect to "/account/changepassword?reason=passwordsdonotmatch"
        else
          time_now = encrypt(Time.now.to_f.to_s)
          set_recovery(time_now, session['user'].email)
          change_password(time_now, encrypt(params[:newpassword]))
          redirect to "/account/changepassword?reason=success"
       end
      end
    end
  end
end
