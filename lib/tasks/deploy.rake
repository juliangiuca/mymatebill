namespace :deploy do

  desc "Runs a local deploy"
  task :unicorns do
    if File.exist?("tmp/pids/unicorn.pid")
      begin
        pid = File.read("tmp/pids/unicorn.pid").to_i
        if pid
          puts "Killing the unicorns"
          Process.kill("QUIT", pid)
          sleep(1)
        end
      rescue Errno::ENOENT, Errno::ESRCH
      end
    end

    puts "Starting the unicorns"
    system("cd #{RAILS_ROOT}; RAILS_ENV=#{Rails.env} bundle exec unicorn_rails -c config/unicorn.rb -E #{Rails.env} -D")
  end
end
