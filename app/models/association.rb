class Association < ActiveRecord::Base
  default_scope :deleted_at => nil
  belongs_to :identity
  belongs_to :associate, :class_name => "Identity"

end
