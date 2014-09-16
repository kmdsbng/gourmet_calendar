class CreateRelEventEventSources < ActiveRecord::Migration
  def change
    create_table :rel_event_event_sources do |t|
      t.integer :event_id
      t.integer :event_source_id

      t.index :event_id
      t.index :event_source_id

      t.timestamps
    end
  end
end
