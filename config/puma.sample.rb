#!/usr/bin/env puma

directory '/home/deployer/apps/pedagogically_website/current'
rackup "/home/deployer/apps/pedagogically_website/current/config.ru"
environment 'production'

pidfile "/home/deployer/apps/pedagogically_website/shared/tmp/pids/puma.pid"
state_path "/home/deployer/apps/pedagogically_website/shared/tmp/pids/puma.state"
stdout_redirect '/home/deployer/apps/pedagogically_website/current/log/puma.error.log', '/home/deployer/apps/pedagogically_website/current/log/puma.access.log', true

threads 4,16

bind 'unix:///home/deployer/apps/pedagogically_website/shared/tmp/sockets/pedagogically_website-puma.sock'

workers 0

preload_app!
on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deployer/apps/pedagogically_website/current/Gemfile"
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end



