# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler'
require 'uri'
require 'json'

Bundler.require(:default, RACK_ENV.to_sym)

## Enable devel logging
Padrino::Logger::Config[:development][:log_level]  = :devel
Padrino::Logger::Config[:development][:log_static] = true

Padrino::Logger::Config[:production][:log_level]  = :info
Padrino::Logger::Config[:production][:log_static] = true

## Configure your I18n
I18n.default_locale = :en

## Configure your HTML5 data helpers
Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
