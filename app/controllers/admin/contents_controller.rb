module Admin
  class ContentsController < AdminController
    def index
      @contents = Content.unposted.ordered
    end
  end
end
