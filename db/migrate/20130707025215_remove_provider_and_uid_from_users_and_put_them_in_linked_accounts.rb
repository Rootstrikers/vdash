class RemoveProviderAndUidFromUsersAndPutThemInLinkedAccounts < ActiveRecord::Migration
  def up
    User.where('provider <> ?', 'system').each do |user|
      user.linked_accounts.create!(provider: user.provider, uid: user.uid)
    end
    remove_column :users, :provider
    remove_column :users, :uid
  end

  def down
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    User.all.each do |user|
      user.uid      = user.linked_accounts.first.uid
      user.provider = user.linked_accounts.first.provider
      user.save!
    end
  end
end
