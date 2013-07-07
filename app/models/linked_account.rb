class LinkedAccount < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid

  def self.for_omniauth(auth)
    where(auth.slice("provider", "uid"))
  end
end
