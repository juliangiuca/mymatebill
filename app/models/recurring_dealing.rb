class RecurringDealing < ActiveRecord::Base
  COPY_ATTRIBUTES = [
    'from_associate_id',
    'to_associate_id',
    'owner_id',
    'description',
    'amount',
    'type'
  ]
    
  belongs_to :owner, :class_name => "Identity"
  belongs_to :to, :foreign_key => "to_associate_id", :class_name => "Identity"
  belongs_to :from, :foreign_key => "from_associate_id", :class_name => "Identity"
  has_many :dealings
  
  validates_presence_of :amount, :start_date, :end_date
  validates_numericality_of :amount
  validates_presence_of :to_associate_id
  validates_presence_of :from_associate_id => Proc.new {|x| x.steps.blank? }
  validates_presence_of :parent_id => Proc.new {|x| x.owner_id.blank? }
  validates_presence_of :rec_type
  
  named_scope :future, lambda {{ :conditions => "start_date >= #{Date.today}", :order => :due }}
  named_scope :past, lambda {{ :conditions => "start_date < #{Date.today}", :order => :due }}
  named_scope :transactions, { :conditions => "type = 'Tranaction'" }
  named_scope :steps, { :conditions => "type = 'Step'" }
  
  ############ rec_type ################ 
  # recurring details encoded in string [type]_[days]_[interval]
  # 
  # type - type of repeating 'weekly', 'monthly'
  # days - [WEEKLY 0-6 (sat-sun)] [MONTHLY 15 (15th of each month)] - comma seperated
  # interval - 3 (every 3 weeks, every 3 fortnights, every 3 months)
  # 
  # For example:
  # weekly_3_1 - every thursday
  # monthly_2_27 - every other month on the 27th
  
  def next_transaction
    return nil if end_date.past?

    dealing = self.dealings.future.first
    if dealing.nil?
      dealing = clone_next_transaction
    end
    
    dealing
  end
  
  private
  
  # initialize next transaction
  def clone_next_transaction(opts={})
    return nil if end_date.past?
    
    # very inefficient
    due_date = nil
    date = Date.today
    while (due_date == nil)
      due_date = next_due_date(date)
      date += 1.day
    end
    
    transaction = Dealing.new()
    transaction.attributes = self.attributes.slice(*COPY_ATTRIBUTES)
    transaction.due = due_date
    transaction.save
    
    self.steps.each do |rec_step|
      step = Dealing.new()
      step.attributes = rec_step.attributes.slice(*COPY_ATTRIBUTES)
      step.due = due_date
      step.parent_id = transaction.id
      step.save
    end
  
    transaction
  end
  
  def next_due_date(date=Date.now)    
    sections = self.rec_type.split('_')
    
    type = sections[0]
    days = sections[1]
    interval = sections[2]
    
    diff = (date - self.start_date).to_i
    
    case type
    when 'weekly'  
      weeks_since = diff / 7
      return date if (interval.split(',').any?{ |inter| (weeks_since % inter.to_i) == 0 }) && days.include?(date.strftime('%w').to_s) && weeks_since > 0
    when 'monthly'
      months_since = diff / 30
      return date if (interval.split(',').any?{ |inter| (months_since % inter.to_i) == 0 }) && days.split(',').any?{ |d| d==date.day.to_s }
    end 
    
    return nil
  end

end
