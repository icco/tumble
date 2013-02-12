class Tumble < Padrino::Application
  register SassInitializer
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  ##
  # Caching support
  #
  register Padrino::Cache
  enable :caching
  set :cache, Padrino::Cache::Store::Memory.new(100)

  OmniAuth.config.logger = logger
  use OmniAuth::Builder do
    provider :identity, :fields => [:email]
    provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  end

  Twitter.configure do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
  end
end
