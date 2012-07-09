app_name = "obtvse"
user_name = "playground"
env = ENV['RAILS_ENV'] || 'development'

preload_app true
worker_processes 4
timeout 30
listen "/tmp/#{app_name}.sock", :backlog => 64

if env == 'development'
  app_root = Dir.pwd
  pid_path = "#{app_root}/tmp/pids"
  
  working_directory app_root
  listen 3000
else
  app_root = "/home/#{user_name}/#{app_name}"
  shared_path = "#{app_root}/shared"
  pid_path = "#{shared_path}/pids"
  
  working_directory "#{app_root}/current"
  stderr_path "#{shared_path}/log/unicorn.stderr.log"
  stdout_path "#{shared_path}/log/unicorn.stdout.log"
end
pid "#{pid_path}/unicorn.#{app_name}.pid"

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{pid_path}/unicorn.#{app_name}.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end