module Admin
  module DeletedThings
    class LinksController < AdminController
      def index
        @links = Link.deleted.paginate(page: params[:page])
      end
    end
  end
end
