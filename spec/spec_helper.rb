$LOAD_PATH << "." unless $LOAD_PATH.include?(".")
require 'rails'
require File.expand_path('../../lib/appmospheres_audit', __FILE__)
require 'ammeter/init'
require 'database_cleaner'
require 'fake_app'
require 'rspec/rails'

RSpec.configure do |config|
  config.before :all do
    CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? :users
  end
end