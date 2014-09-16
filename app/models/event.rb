class Event < ActiveRecord::Base
  has_many :rel_event_event_sources
  has_many :event_ranges

end
