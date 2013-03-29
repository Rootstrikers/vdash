module Admin
  module DeletedThings
    class TwitterContentsController < AdminController
      def index
        @contents = TwitterContent.deleted.paginate(page: params[:page])
      end
    end
  end
end
