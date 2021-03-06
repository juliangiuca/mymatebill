# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

      admin = Account.find_by_login("admin")
      if admin
        puts "Admin already exists"
      else
        admin = Account.create!(
          :login      => "admin",
          :email      => "julian.giuca@gmail.com",
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
