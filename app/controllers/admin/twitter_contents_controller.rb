module Admin
  class TwitterContentsController < AdminController
    def index
      @contents = TwitterContent.unposted.ordered
    end
  end
end
