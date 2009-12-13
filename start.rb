#!/usr/bin/env ruby
system("flush manage")
system("rake db:migrate")
system("rake db:test:prepare")
#system("rake site:bootstrap")
