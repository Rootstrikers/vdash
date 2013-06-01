class AddPublicContactInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_contact_information, :boolean, default: false
  end
end
