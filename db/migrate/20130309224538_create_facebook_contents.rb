class CreateFacebookContents < ActiveRecord::Migration
  def change
    create_table :facebook_contents do |t|
      t.references :link
      t.references :user
      t.text :body

      t.timestamps
    end
    add_index :facebook_contents, :link_id
    add_index :facebook_contents, :user_id
  end
end
