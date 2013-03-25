require 'active_support/concern'

module Deletable
  extend ActiveSupport::Concern

  included do
    default_scope where(deleted_at: nil)
  end

  def fake_delete
    update_attribute(:deleted_at, Time.now)
  end
end
