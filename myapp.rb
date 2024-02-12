require 'sinatra/activerecord'
require 'sinatra'
require './models/message'
require './models/user'

configure :production do
  set :database, { adapter: 'sqlite3', database: '/tmp/minitwit.db' }
  enable :sessions
end

configure :test do
  set :database, { adapter: 'sqlite3', database: '/tmp/minitwit_test.db' }
  enable :sessions
end

helpers do
  def nil_or_empty?(string)
    string.nil? || string.empty?
  end
end

get '/' do
  Message.all.map do |message|
    Rack::Utils.escape_html(message.text)
  end
end

get '/register' do
  erb :index
end

post '/register' do
  if nil_or_empty?(params[:username])
    error = 'You have to enter a username'
  elsif nil_or_empty?(params[:email]) || params[:email] !~ /@/
    error = 'You have to enter a valid email address'
  elsif nil_or_empty?(params[:password])
    error = 'You have to enter a password'
  elsif params[:password] != params[:password2]
    error = 'The two passwords do not match'
  elsif User.find_by_username(params[:username])
    error = 'The username is already taken'
  elsif User.create(
    username: params[:username],
    email: params[:email],
    password: params[:password],
    password_confirmation: params[:password2]
  )
    return 'You were successfully registered and can login now'
  else
    error = 'Something went wrong :('
  end
  return error
end

post '/login' do
  user = User.find_by_username(params[:username])
  if user.nil?
    error = 'Invalid username'
  elsif !user.authenticate(params[:password])
    error = 'Invalid password'
  else
    session[:user_id] = user.id
    return 'You were logged in'
  end
  return error
end

get '/logout' do
  session[:user_id] = nil
  return 'You were logged out'
end

post '/add_message' do
  if !session[:user_id]
    return status 401
  elsif params[:text]
    if Message.create(
      author_id: session[:user_id],
      text: params[:text],
      pub_date: Time.now,
      flagged: 0
    ) then return 'Your message was recorded'
    else
      error = 'Something went wrong :('
    end

    return error
  end
end
