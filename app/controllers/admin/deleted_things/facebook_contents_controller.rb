module Admin
  module DeletedThings
    class FacebookContentsController < AdminController
      def index
        @contents = FacebookContent.deleted.paginate(page: params[:page])
      end
    end
  end
end
