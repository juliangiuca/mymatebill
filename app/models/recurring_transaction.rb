class RecurringTransaction < RecurringDealing
  has_many :steps, :foreign_key => "parent_id", :class_name => "Step", :dependent => :destroy
end
