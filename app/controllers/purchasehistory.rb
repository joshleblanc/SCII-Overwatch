require_relative "base.rb"

module Site
  module Routes
    class PurchaseHistory < Base
      get '/purchasehistory/?' do
        authorize!
        res = browse_books
        if res[:foundrecord][:foundrecord_items].nil?
          @books = [res[:foundrecord]]
        else
          @books = res[:foundrecord][:foundrecord_items]
        end
        @books.map do |book|
          date = book[:browsebookdate]
          date = date.insert(4, '/').insert(7, '/')
          book[:browsebookdate] = date
          book
        end
        render_page :purchase_history
      end
    end
  end
end
