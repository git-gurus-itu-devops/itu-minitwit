# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra'
require 'sinatra/flash'
require './models/message'
require './models/user'

PR_PAGE = 30

configure :production, :development do
  set :database, { adapter: 'sqlite3', database: '/tmp/minitwit.db' }
  set :public_folder, "#{__dir__}/static"
  enable :sessions
end

configure :test do
  set :database, { adapter: 'sqlite3', database: '/tmp/minitwit_test.db' }
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

    User.find(session[:user_id])
  end
end

get '/' do
  redirect('/public') unless logged_in?
  user = current_user
  @messages = Message.where(author_id: user.following << user).last(PR_PAGE).reverse
  erb :timeline, layout: :layout
end

get '/public' do
  @messages = Message.last(PR_PAGE).reverse
  erb :timeline, layout: :layout
end

get '/register' do
  erb :register, layout: :layout
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
    flash[:success] = 'You were successfully registered and can login now'
    redirect('/login')
  else
    error = 'Something went wrong'
  end
  flash[:error] = error
  redirect('/register')
end

get '/login' do
  erb :login, layout: :layout
end

post '/login' do
  user = User.find_by_username(params[:username])
  if user.nil?
    error = 'Invalid username'
  elsif !user.authenticate(params[:password])
    error = 'Invalid password'
  else
    session[:user_id] = user.id
    flash[:success] = 'You were logged in'
    redirect('/')
  end
  flash[:error] = error
  redirect('/login')
end

get '/logout' do
  session[:user_id] = nil

  'You were logged out'
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
    )
      flash[:success] = 'Your message was recorded'
    end
  else
    flash[:error] = 'Something went wrong :('
  end

  redirect('/')
end

get '/:username' do
  @profile_user = User.find_by_username(params[:username])
  @messages = Message.where(author_id: @profile_user).last(PR_PAGE).reverse
  erb :timeline, layout: :layout
end

get '/:username/follow' do
  return status 401 unless logged_in?

  whom = User.find_by_username(params[:username])
  current_user.following << whom
  flash[:success] = "You are now following &#34;#{params[:username]}&#34;"
  redirect("/#{params[:username]}")
end

get '/:username/unfollow' do
  return status 401 unless logged_in?

  whom = User.find_by_username(params[:username])
  current_user.following.delete(whom)
  flash[:success] = "You are no longer following &#34;#{params[:username]}&#34;"
  redirect("/#{params[:username]}")
end
