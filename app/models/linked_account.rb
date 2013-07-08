class LinkedAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid

  def self.for_omniauth(auth)
    where(auth.slice("provider", "uid"))
  end

  def self.available_providers_for(user)
    ['facebook', 'twitter', 'google_oauth2'] - user.linked_accounts.pluck(:provider)
  end

  def self.label_for_provider(provider)
    {
      'facebook'      => 'Facebook',
      'twitter'       => 'Twitter',
      'google_oauth2' => 'Google'
    }[provider]
  end

  def label
    self.class.label_for_provider(provider)
  end
end
