class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :content_id
      t.string :content_type
      t.references :user

      t.timestamps
    end
    add_index :posts, :user_id
  end
end
