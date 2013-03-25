module Admin
  class FacebookContentsController < AdminController
    def index
      @contents = FacebookContent.unposted.ordered
    end
  end
end
