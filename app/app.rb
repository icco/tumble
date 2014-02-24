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

  OmniAuth.config.logger = logger
  use OmniAuth::Builder do
    provider :identity, :fields => [:email]
    provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  end

  Twitter.configure do |config|
    config.consumer_key = ENV['TWITTER_KEY']
    config.consumer_secret = ENV['TWITTER_SECRET']
  end

  I18n.enforce_available_locales = false
end

module OmniAuth
  module Strategies
    class Identity
      def request_phase
        redirect '/login'
      end
    end
  end
end
