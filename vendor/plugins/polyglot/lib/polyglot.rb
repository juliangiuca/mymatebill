
module Polyglot
  
  # @@languages
  # contains a hash of this form:
  # {
  #    'ro' => {'key1' => 'value1_ro', 'key2' => 'value2_ro' },
  #    'en' => {'key1' => 'value1_en', 'key2' => 'value2_en' },
  #    'de' => {'key1' => 'value1_de', 'key2' => 'value2_de' },
  #    ...
  # }
  @@languages           = {}
  
  # @@available_languages
  # contains the available languages in an array: ['ro', 'en', 'de', 'fr', ...]
  @@available_languages = []
  
  # @@updated_time
  # remember the last updated time for the dictionaries; this is only used
  # in development mode, to determine when a dictionary was changed and reload it
  @@updated_time        = Time.now
  
  # @@default_language
  # set the default language
  @@default_language = 'en'
  
  def default_language
    @@default_language
  end
  
  def default_language=(lang)
    @@default_language = lang
  end
  
  # initialize the dictionaries
  Dir.chdir("vendor/plugins/polyglot/languages") do
    Dir.glob("*.yml").each do |f| 
      lang = File.basename(f, ".*")
      @@available_languages << lang
      @@languages[lang] ||= {}
      @@languages[lang].merge! YAML.load_file(f)
    end
  end

  # available_languages
  # Returns an array with the available languages for the application.
  # For example ['en', 'ro', 'fr', 'de']
  def available_languages
    @@available_languages.join(", ")
  end
  
  # _
  # Returns the message using the language settings for the application.
  # Default is ENGLISH, change it according to your needs.
  def _(key, lang = default_language, *params)
    # reload dictionaries if necessary and in development mode
    load_keys if defined?(RAILS_ENV) && RAILS_ENV == 'development'
    # read the value for the specified key
    value = get_msg(key, lang).to_s    
    # replace the params placeholders ({0}, {1}, ...) if any
    params.each_with_index do |p, i|
      value = value.gsub("{#{i}}", p.to_s)
    end
    value
  end
  
private
  
  # return the value from the dictionary
  def get_msg(key, lang)
    (@@languages[lang])[key]
  end 
  
  # reload the dictionary if necesary; checks the last updated time for the
  # dictionary file and reloads it if it was updated since the last load
  def load_keys
    Dir.chdir("vendor/plugins/polyglot/languages") do
      # we need the latest updated time. if more than one dictionary (i.e. both en.yml and es.yml)
      # were updated, we only need the latest update time, so we use this last_updated_time variable
      last_updated_time = @@updated_time
      
      Dir.glob("*.yml").each do |f| 
        lang = File.basename(f, ".*")
        @@available_languages << lang
        @@languages[lang] ||= {}
        
        # reload the file only if it was updated since the last load
        modified_file_time = File.mtime(f)
        if @@updated_time < modified_file_time
          # update the last_updated_time variable if necessary
          last_updated_time =  modified_file_time if last_updated_time <  modified_file_time 
          # reload the dictionary
          @@languages[lang] = YAML.load_file(f)
          # log the reload
          logger.info("\n\n ^^^^^^^^ [POLYGLOT]: reloading #{f} ^^^^^^^^ \n\n") if defined?(logger)
        end
      end
      # update the internal flag
      @@updated_time = last_updated_time
      
    end
  end

end