module Admin
  class BansController < AdminController
    def index
      @bans = Ban.newest_first.paginate(page: params[:page])
    end
  end
end
