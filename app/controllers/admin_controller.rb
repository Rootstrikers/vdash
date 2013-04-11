class AdminController < ApplicationController
  before_filter :require_admin
  skip_before_filter :ensure_not_banned
end
