class RemoveContentTypeFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :content_type
  end

  def down
    add_column :posts, :content_type, :string
  end
end
