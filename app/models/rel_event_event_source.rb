class RelEventEventSource < ActiveRecord::Base
  belongs_to :event_source
  belongs_to :event

end
