# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra'
require './models/message'
require './models/user'
require 'json'

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

helpers do
  def nil_or_empty?(string)
    string.nil? || string.empty?
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    return nil unless logged_in?

    @current_user ||= User.find(session[:user_id])
  end
end

def validate_create_user(params)
  if nil_or_empty?(params[:username])
    error = 'You have to enter a username'
  elsif nil_or_empty?(params[:email]) || params[:email] !~ /@/
    error = 'You have to enter a valid email address'
  elsif nil_or_empty?(params[:pwd])
    error = 'You have to enter a password'
  elsif User.find_by_username(params[:username])
    error = 'The username is already taken'
  end
  error
end

post '/register' do
  # TODO: update latest

  request_data = JSON.parse(request.body.read, symbolize_names: true)

  error = validate_create_user(request_data)
  if !error && !User.create(
    username: request_data[:username],
    email: request_data[:email],
    password: request_data[:pwd],
    password_confirmation: request_data[:pwd]
  )
    error = 'Something went wrong'
  end
  if error
    status 400
    return { 'status' => 400, 'error_msg' => error }.to_json
  else
    status 204
    body ''
  end
end
