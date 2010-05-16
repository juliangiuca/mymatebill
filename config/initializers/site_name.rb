#Load the sites name and url for production and dev
  site = YAML::load(File.open("#{RAILS_ROOT}/config/site.yml"))
  @@site = site[RAILS_ENV] unless site[RAILS_ENV].blank?
