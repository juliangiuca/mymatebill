class Association < ActiveRecord::Base
  default_scope :deleted_at => nil
  belongs_to :identity
  belongs_to :associate, :class_name => "Identity"

  def apple
    return "hai"
  end

  def self.apple
    return "hai"
  end
  
end
