class LinkedAccountsController < ApplicationController
  before_filter :require_user

  def index
    @linked_accounts     = current_user.linked_accounts
    @available_providers = LinkedAccount.available_providers_for(current_user)
  end
end
