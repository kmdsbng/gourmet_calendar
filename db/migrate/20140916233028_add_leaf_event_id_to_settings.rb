class AddLeafEventIdToSettings < ActiveRecord::Migration
  class Setting < ActiveRecord::Base
  end

  def up
    unless Setting.where(:name => 'leaf_event_id').exists?
      Setting.create!(:name => 'leaf_event_id', :num => 450)
    end
  end

  def down
  end
end
