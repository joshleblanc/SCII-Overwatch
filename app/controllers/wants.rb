require_relative "base.rb"

module Site
  module Routes
    class Wants < Base
      post '/wants/details/:key/edit/?' do
        p "NOTE: #{params[:note]}"
        usedonly = convert_used_only params[:usedonly]
        edit_want(
          params[:recorddigest],
          params[:key],
          params[:title],
          params[:author],
          params[:surname],
          params[:binding],
          params[:note],
          usedonly
        )
        redirect to "/wants/details/#{params[:key]}"
      end

      post '/wants/new' do
        usedonly = convert_used_only params[:usedonly]
        add_want(
          params[:title],
          params[:author],
          params[:surname],
          params[:binding],
          params[:note],
          usedonly
        )
        redirect to "/wants/#{params[:key]}"
      end

      get '/wants/?' do
        authorize!
        res = browse_wants
        if res[:foundrecord][:foundrecord_items].nil?
          @wants = [res[:foundrecord]]
        else
          @wants = res[:foundrecord][:foundrecord_items]
        end
        render_page :wants
      end

      get '/wants/details/:key/?' do
        authorize!
        @want = read_want params[:key]
        render_page :want_detail
      end

      get '/wants/details/:key/edit/?' do
        authorize!
        @want = read_want params[:key]
        render_page :want_edit
      end

      post '/wants/details/:key/delete/?' do
        delete_want(params[:recorddigest], params[:key])
        redirect to '/wants'
      end

      get '/wants/new/?' do
        render_page :want_new
      end

      private
        def convert_used_only(uo)
          if uo.nil?
             return "0"
          else
             return "1"
          end
        end
    end
  end
end
