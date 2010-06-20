namespace :site do
  namespace :friend do
    desc "add a friend to the default user"
    task :create => :environment do
      admin = Account.find_by_login("admin")
      if admin
        admin.identity.associates.create!(:name => "timmy")
        puts "Friend Created"
      end
    end
  end
end

