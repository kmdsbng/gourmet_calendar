class CreateEventRanges < ActiveRecord::Migration
  def change
    create_table :event_ranges do |t|
      t.date :start_on
      t.integer :start_hour
      t.integer :start_min
      t.date :end_on
      t.integer :end_hour
      t.integer :end_min

      t.index [:start_on, :end_on]
      t.index :end_on

      t.timestamps
    end
  end
end
