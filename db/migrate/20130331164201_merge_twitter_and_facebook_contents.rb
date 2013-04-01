class MergeTwitterAndFacebookContents < ActiveRecord::Migration
  def up
    create_table :contents do |t|
      t.references :link
      t.references :user
      t.text :body
      t.integer :like_count

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :contents, :link_id
    add_index :contents, :user_id

    execute "insert into contents (link_id, user_id, body, like_count, created_at, updated_at) select link_id, user_id, body, like_count, created_at, updated_at from twitter_contents"
    execute "insert into contents (link_id, user_id, body, like_count, created_at, updated_at) select link_id, user_id, body, like_count, created_at, updated_at from facebook_contents"

    drop_table :twitter_contents
    drop_table :facebook_contents
  end

  def down
    drop_table :contents

    create_table :twitter_contents do |t|
      t.references :link
      t.references :user
      t.text :body
      t.integer :like_count

      t.timestamps
    end
    add_index :twitter_contents, :link_id
    add_index :twitter_contents, :user_id

    create_table :facebook_contents do |t|
      t.references :link
      t.references :user
      t.text :body
      t.integer :like_count

      t.timestamps
    end
    add_index :facebook_contents, :link_id
    add_index :facebook_contents, :user_id
  end
end
