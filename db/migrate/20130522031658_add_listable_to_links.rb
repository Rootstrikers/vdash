class AddListableToLinks < ActiveRecord::Migration
  def change
    add_column :links, :listable, :boolean, default: true
  end
end
