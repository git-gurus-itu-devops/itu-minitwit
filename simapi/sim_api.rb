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

def update_latest(request)
  parsed_command_id = request.params['latest'].to_i || -1

  File.write('./latest_processed_sim_action_id.txt', parsed_command_id.to_i, mode: 'w') if parsed_command_id != -1
end

get '/latest' do
  begin
    content = File.read('latest_processed_sim_action_id.txt')
    latest_processed_command_id = content.to_i
  rescue StandardError
    latest_processed_command_id = -1
  end

  JSON.generate({ latest: latest_processed_command_id })
end

post '/register' do
  update_latest(request)

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
