PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path('../../config/boot', __FILE__)

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
  include Rack::Test::Methods

  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    Tumble.tap { |app|  }
  end
end
