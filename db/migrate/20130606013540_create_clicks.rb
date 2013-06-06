class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.references :user
      t.references :item, polymorphic: true

      t.timestamps
    end
    add_index :clicks, :user_id
    add_index :clicks, [:item_id, :item_type]
  end
end
