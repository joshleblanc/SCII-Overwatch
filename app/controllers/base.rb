module Site
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, App.root
        set :session_secret, "thisstringwillnotchange"
        set :protection, except: :session_hijacking
        # enable :run
        # #enable :static
        enable :sessions
        disable :static

        set :haml, layout_options: {views: 'app/views/layouts'}
      end

      helpers Helpers

    end
  end
end
