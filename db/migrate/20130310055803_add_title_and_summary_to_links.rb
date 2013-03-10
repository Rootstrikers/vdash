class AddTitleAndSummaryToLinks < ActiveRecord::Migration
  def change
    add_column :links, :title, :string
    add_column :links, :summary, :text
  end
end
