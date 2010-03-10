namespace :site do
  namespace :friend do
    desc "add a friend to the default user"
    task :create => :environment do
      admin = User.find_by_login("admin")
      if admin
        admin.friends.create!(:name => "timmy")
        puts "Friend Created"
      end
    end
  end
end

