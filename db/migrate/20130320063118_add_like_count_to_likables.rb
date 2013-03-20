class AddLikeCountToLikables < ActiveRecord::Migration
  def change
    add_column :links, :like_count, :integer
    add_column :twitter_contents, :like_count, :integer
    add_column :facebook_contents, :like_count, :integer
  end
end
