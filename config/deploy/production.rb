role :web, "foochr.com"
role :app, "foochr.com"
role :db,  "foochr.com", :primary => true
role :db,  "foochr.com", :no_release => true
set :deploy_to, "/home/www/mymatebill.com/www"

