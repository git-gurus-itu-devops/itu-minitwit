require 'sinatra/activerecord'
require 'sinatra'

set :database, {adapter:'sqlite3', database: '/tmp/minitwit.db'}

get '/' do
    Message.last.text
end
