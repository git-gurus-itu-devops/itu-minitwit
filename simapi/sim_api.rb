# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra'
require './models/message'
require './models/user'
require 'json'

DATABASE_PATH = ENV['DATABASE_PATH'] || './db/minitwit.db'

configure :production do
  set :database, { adapter: 'sqlite3', database: DATABASE_PATH }
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

  def request_is_not_from_simulator
    request.env['HTTP_AUTHORIZATION'] != 'Basic c2ltdWxhdG9yOnN1cGVyX3NhZmUh'
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

before do
  if request_is_not_from_simulator
    halt [403, { status: 403, error_msg: 'You are not authorized to use this resource!' }.to_json]
  elsif request.path_info == '/latest'
    pass
  end

  update_latest(request)
end

get '/latest' do
  begin
    content = File.read('latest_processed_sim_action_id.txt')
    latest_processed_command_id = content.to_i
  rescue StandardError
    latest_processed_command_id = -1
  end

  body({ latest: latest_processed_command_id }.to_json)
end

post '/register' do
  request_data = JSON.parse(request.body.read, symbolize_names: true)

  error = validate_create_user(request_data)
  if error
    status 400
    body({ status: 400, error_msg: error }.to_json)
  elsif !User.create(
    username: request_data[:username],
    email: request_data[:email],
    password: request_data[:pwd],
    password_confirmation: request_data[:pwd]
  )
    status 400
    body({ status: 400, error_msg: 'Something went wrong' }.to_json)
  else
    status 204
  end
end

get '/msgs' do
  return [400, 'no is required'] if params[:no].nil?
  count = params[:no].to_i

  return Message
    .unflagged
    .order(pub_date: :desc)
    .first(count)
    .map(&:sim_format)
    .to_json
end

get '/msgs/:username' do |username|
  user = User.find_by_username(username)
  return [400, 'User not found'] if user.nil?
  return [400, 'no is required'] if params[:no].nil?
  count = params[:no].to_i

  return user.messages
    .unflagged
    .order(pub_date: :desc)
    .first(count)
    .map(&:sim_format)
    .to_json
end

post '/msgs/:username' do |username|
  user = User.find_by_username(username)
  return [400, 'User not found'] if user.nil?

  request_data = JSON.parse(request.body.read, symbolize_names: true)
  message = user.messages.create(
    text: request_data[:content],
    pub_date: Time.now,
    flagged: 0
  )

  if message
    status 201
    body message.to_json
  else
    status 400
    body 'Something went wrong'
  end
end

get '/fllws/:username' do |username|
  user = User.find_by_username(username)
  return [400, 'User not found'] if user.nil?
  return [400, 'no is required'] if params[:no].nil?
  count = params[:no].to_i

  following = user.following
    .first(count)
    .pluck(:username)

  status 200
  body({ follows: following }.to_json)
end

post '/fllws/:username' do |username|
  user = User.find_by_username(username)
  return [400, 'User not found'] if user.nil?

  request_data = JSON.parse(request.body.read, symbolize_names: true)
  if request_data.key?(:follow)
    to_follow = User.find_by_username(request_data[:follow])
    return [400, 'User to follow not found'] if to_follow.nil?

    user.following.append(to_follow)
    status 200
  elsif request_data.key?(:unfollow)
    to_unfollow = User.find_by_username(request_data[:unfollow])
    return [400, 'User to unfollow not found'] if to_unfollow.nil?

    user.following.delete(to_unfollow)
    status 200
  end
end
