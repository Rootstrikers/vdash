class AddExtraAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :full_name, :string
    add_column :users, :email, :string
    add_column :users, :birthday, :string
    add_column :users, :description, :text
    add_column :users, :image, :string
    add_column :users, :location, :string
    add_column :users, :gender, :string
    add_column :users, :twitter_url, :string
    add_column :users, :facebook_url, :string
    add_column :users, :google_url, :string
    add_column :users, :website_url, :string
  end
end
