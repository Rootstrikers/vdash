class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.references :user
      t.references :created_by
      t.datetime :created_at
      t.text :reason

      t.timestamps
    end
    add_index :bans, :user_id
    add_index :bans, :created_by_id
  end
end
