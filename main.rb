require 'sinatra'
require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/cookies'
require 'data_mapper'
require 'haml'
require 'savon'
require 'encryptor'
require 'pony'
require 'tassadar'

module Site
	class App < Sinatra::Application
		DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/data.db")

		Dir["./app/models/*.rb"].each { |file| require file }
		Dir["./app/helpers/*.rb"].each { |file| require file }
		Dir["./app/controllers/*.rb"].each { |file| require file }

		use Routes::Index
		use Routes::Submit
		use Routes::Games
		DataMapper.auto_upgrade!
		DataMapper.finalize
	end
end
