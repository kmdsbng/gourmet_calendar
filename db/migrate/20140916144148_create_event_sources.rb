class CreateEventSources < ActiveRecord::Migration
  def change
    create_table :event_sources do |t|
      t.string :url, :null => false
      t.string :title
      t.string :place_str
      t.string :range_str
      t.string :source_type
      t.boolean :event_created, :default => false
      t.boolean :ignored, :default => false
      t.boolean :import_success, :default => true
      t.string :import_error_code
      t.text :import_error_description

      t.index :url, :unique => true

      t.timestamps
    end
  end
end
