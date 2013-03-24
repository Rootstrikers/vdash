class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.references :user
      t.boolean :active, default: true
      t.text :body

      t.timestamps
    end
    add_index :notices, :user_id
  end
end
