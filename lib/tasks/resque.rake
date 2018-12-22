require 'resque/tasks'

namespace :resque do
  task :setup => :environment do
    require 'resque'

    Resque.redis = if Rails.env.production?
      uri = URI.parse(ENV["REDIS_URL"])
      Redis.new(host: uri.host, port: uri.port, password: uri.password)
    else
      "localhost:6379"
    end
  end
end

Resque.after_fork = Proc.new{ActiveRecord::Base.establish_connection}

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
