class HomeController < ApplicationController
  skip_before_filter :ensure_not_banned, only: :index

  def index
  end

  def sign_in
  end
end
