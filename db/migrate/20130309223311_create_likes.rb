class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :item_id
      t.string :item_type
      t.references :user

      t.timestamps
    end
    add_index :likes, :user_id
  end
end
