class MakeLikeCountDefaultToZeroOnLikableThings < ActiveRecord::Migration
  def up
    change_column :links, :like_count, :integer, default: 0
    change_column :contents, :like_count, :integer, default: 0

    Link.where(like_count: nil).update_all(like_count: 0)
    Content.where(like_count: nil).update_all(like_count: 0)
  end

  def down
    change_column :links, :like_count, :integer
    change_column :contents, :like_count, :integer
  end
end
