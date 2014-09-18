class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.integer :num
      t.string :str

      t.index :name, :unique => true

      t.timestamps
    end
  end
end
