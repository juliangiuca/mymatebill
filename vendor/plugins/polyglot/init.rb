require File.join(Rails.root, 'vendor/plugins/polyglot/lib/polyglot.rb')

# Make the Polyglot methods available in models, views and controllers and also tests

class ActiveRecord::Base
  extend Polyglot
end

class Test::Unit::TestCase
  include Polyglot
end

class ActionController::Base
  include Polyglot
end

class ActionView::Base
  include Polyglot
end

class ActionMailer::Base
  include Polyglot
end
