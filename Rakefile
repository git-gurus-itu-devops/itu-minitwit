# frozen_string_literal: true

require "sinatra/activerecord/rake"

Dir.glob("tasks/*.rake").each { |r| load r }

namespace :db do
  task :load_config do
    require "./myapp"
  end
end
