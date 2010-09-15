module ActiveRecord
  class Base
    cattr_accessor :current_user

    def current_user
      self.class.current_user
    end
  end
end
