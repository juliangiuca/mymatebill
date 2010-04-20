namespace :site do
  desc "wipe the DB"
  task :nuke => :environment do
    Rake::Task["db:drop:all"].invoke
    Rake::Task["db:create:all"].invoke
    puts "system purged"
  end

  desc "wipe and recreate the site"
  task :bootstrap => :environment do
    #system 'rake site:nuke && rake db:setup && rake site:friend:create && rake db:test:prepare'
    Rake::Task["db:drop:all"].invoke rescue
    Rake::Task["db:create:all"].invoke
    Rake::Task["db:setup"].invoke
    Rake::Task["site:friend:create"].invoke
    ##for some reason, this prevents the account from being created. GG.
    Rake::Task["db:test:prepare"].invoke
  end

end
