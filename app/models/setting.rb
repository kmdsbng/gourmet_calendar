class Setting < ActiveRecord::Base

  def self.load_leaf_event_id
    Setting.where(:name => 'leaf_event_id').first.num
  end

  def self.save_leaf_event_id(event_id)
    Setting.where(:name => 'leaf_event_id').first.update_attribute(:num, event_id)
  end
end
