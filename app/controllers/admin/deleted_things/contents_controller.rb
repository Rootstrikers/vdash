module Admin
  module DeletedThings
    class ContentsController < AdminController
      def index
        @contents = Content.deleted.paginate(page: params[:page])
      end
    end
  end
end
