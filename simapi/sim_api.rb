# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra'
require './models/message'
require './models/user'

configure :production do
  set :database, { adapter: 'sqlite3', database: './db/minitwit.db' }
  set :public_folder, "#{__dir__}/static"
  enable :sessions
end

configure :development do
  set :database, { adapter: 'sqlite3', database: './db/minitwit_dev.db' }
  set :public_folder, "#{__dir__}/static"
  ActiveRecord.verbose_query_logs = true
  enable :sessions
end

configure :test do
  set :database, { adapter: 'sqlite3', database: './db/minitwit_test.db' }
  enable :sessions
  enable :logging
  ActiveRecord::Base.logger = Logger.new($stdout)
end