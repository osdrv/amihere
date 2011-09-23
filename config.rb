require 'rubygems'

(ENV ||= {})["RACK_ENV"] ||= :development
RACK_ENV = ENV["RACK_ENV"]

set :root, File.dirname(__FILE__)
set :run, false
set :bind, "localhost"
set :port, "9191"

gemfile = File.expand_path(File.join(settings.root, "Gemfile"))

require "bundler/setup"
require "sinatra"
require "haml"
require "ohm"
require "time"

begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)

Bundler.require(:default, RACK_ENV) if defined?(Bundler)

Dir[File.join(settings.root, "model", "*.rb")].each do |f|
  require f
end
