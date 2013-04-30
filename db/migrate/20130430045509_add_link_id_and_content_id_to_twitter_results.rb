class AddLinkIdAndContentIdToTwitterResults < ActiveRecord::Migration
  def change
    add_column :twitter_results, :link_id, :integer
    add_column :twitter_results, :content_id, :integer

    add_index :twitter_results, :link_id
    add_index :twitter_results, :content_id
  end
end
