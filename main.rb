require 'sinatra'
require 'sinatra/base'
require 'sinatra/static_assets'
require 'sinatra/cookies'
require 'haml'
require 'savon'
require 'encryptor'
require 'pony'

module Site
	class App < Sinatra::Application
		Dir["./app/models/*.rb"].each { |file| require file }
		Dir["./app/helpers/*.rb"].each { |file| require file }
		Dir["./app/controllers/*.rb"].each { |file| require file }

		use Routes::Account
		use Routes::Error
		use Routes::Index
		use Routes::Login
		use Routes::Recovery
		use Routes::Wants
		use Routes::PurchaseHistory
		use Routes::Logout
	end
end
