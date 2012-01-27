require 'active_record'
require 'action_controller/railtie'
require 'action_view/railtie'

# database
ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

# config
app = Class.new(Rails::Application)
app.config.secret_token = "fada08cee25221c8f94cd4469710c402fc40c4100a2f72f101f18233002f7016fc7004c09e68e201dbcf1bf92d5bfec98638ac239590980352e56b406dc50286"
app.config.session_store :cookie_store, :key => "_myfakeapp_session"
app.config.active_support.deprecation = :log
app.initialize!

# routes
app.routes.draw do
  resources :users
end

# models
class User < ActiveRecord::Base
  enable_record_tracking
end

# controllers
class ApplicationController < ActionController::Base
  enable_action_tracking
end
class UsersController < ApplicationController
  def index
    @users = User.all
    render :inline => <<-ERB
<%= @users.map(&:name).join("\n") %>
ERB
  end
end

# helpers
Object.const_set(:ApplicationHelper, Module.new)

#migrations
class CreateAllTables < ActiveRecord::Migration

  def self.up

    create_table(:users) {|t| t.string :name }

    create_table :event_logs do |t|
      t.string :event_type
      t.string :action
      t.text :payload

      t.datetime :reported_at
      t.timestamps
    end

  end

  def self.down
    drop_table :event_logs
    drop_table :users
  end

end
