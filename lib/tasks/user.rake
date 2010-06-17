namespace :site do
  namespace :account do
    desc "add a default user"
    task :create => :environment do
      admin = Account.find_by_login("admin")
      if admin
        puts "Admin already exists"
      else
        admin = Account.create!(
          :login      => "admin",
          :email      => "julian@giuca.com",
          :password   => "test123",
          :password_confirmation => "test123")
          admin.state = "active"
          admin.save!

          if admin
            puts "Admin account created"
          else
            puts "admin account creation failed"
          end
      end
    end
  end
end
