class Tumble < Padrino::Application
  register SassInitializer
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  if PADRINO_ENV != "development"
    use Honeybadger::Rack
  end

  ##
  # Caching support
  #
  register Padrino::Cache
  enable :caching
  set :cache, Padrino::Cache::Store::Memory.new(100)

  OmniAuth.config.logger = logger
  use OmniAuth::Builder do
    provider :identity, :fields => [:email]
  end
end
