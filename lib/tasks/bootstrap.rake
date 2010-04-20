namespace :site do
  desc "wipe the DB"
  task :nuke => :environment do
    Rake::Task["db:drop:all"].invoke
    Rake::Task["db:create:all"].invoke
    puts "system purged"
  end

  desc "wipe and recreate the site"
  task :bootstrap => :environment do
    system 'rake site:nuke && rake db:migrate && rake db:seed && rake site:friend:create && rake db:test:prepare'
  end

end
