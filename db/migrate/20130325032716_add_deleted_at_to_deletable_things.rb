class AddDeletedAtToDeletableThings < ActiveRecord::Migration
  def change
    add_column :links, :deleted_at, :datetime
    add_column :twitter_contents, :deleted_at, :datetime
    add_column :facebook_contents, :deleted_at, :datetime
  end
end
