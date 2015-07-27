require_relative "base.rb"

module Site
  module Routes
    class Index < Base
      get '/' do
         redirect to("/list/recent")
      end

    end
  end
end
