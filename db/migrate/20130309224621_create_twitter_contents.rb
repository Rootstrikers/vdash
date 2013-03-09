class CreateTwitterContents < ActiveRecord::Migration
  def change
    create_table :twitter_contents do |t|
      t.references :link
      t.references :user
      t.text :body

      t.timestamps
    end
    add_index :twitter_contents, :link_id
    add_index :twitter_contents, :user_id
  end
end
