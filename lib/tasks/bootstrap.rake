namespace :site do
  desc "wipe the DB"
  task :nuke => :environment do
    system("flush manage")
    puts "system purged"
  end

  desc "wipe and recreate the site"
  task :bootstrap => :environment do
    Rake::Task["site:nuke"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["site:user:create"].invoke
    Rake::Task["site:friend:create"].invoke
    #for some reason, this prevents the account from being created. GG.
    Rake::Task["db:test:prepare"].invoke
  end

end
