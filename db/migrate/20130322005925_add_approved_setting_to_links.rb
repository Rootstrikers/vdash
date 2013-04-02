class AddApprovedSettingToLinks < ActiveRecord::Migration
  def change
  	add_column :links, :approved, :boolean
  end
end
