require 'sinatra/activerecord'
require 'sinatra'
require './models/message'
require './models/user'

set :database, { adapter: 'sqlite3', database: '/tmp/minitwit.db' }

helpers do
  def nil_or_empty?(string)
    string.nil? || string.empty?
  end
end

get '/' do
  Message.last.text
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
