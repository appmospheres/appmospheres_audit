class EventLog < ActiveRecord::Base

  attr_accessible :event_type, :action, :payload

end