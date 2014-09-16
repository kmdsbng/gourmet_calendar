class CreateEventSources < ActiveRecord::Migration
  def change
    create_table :event_sources do |t|
      t.string :url
      t.string :title
      t.string :place_str
      t.string :range_str
      t.string :source_type
      t.boolean :event_created
      t.boolean :ignored

      t.index :url

      t.timestamps
    end
  end
end
