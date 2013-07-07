class CreateLinkedAccounts < ActiveRecord::Migration
  def change
    create_table :linked_accounts do |t|
      t.references :user
      t.string :uid
      t.string :provider

      t.timestamps
    end
    add_index :linked_accounts, :user_id
  end
end
