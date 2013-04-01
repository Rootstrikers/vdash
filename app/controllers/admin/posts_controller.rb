module Admin
  class PostsController < AdminController
    before_filter :find_content, only: [:create]

    def index
      @posts = Post.order('created_at desc').paginate(page: params[:page])
    end

    def create
      @content.post!(service: params[:type].to_sym)
      redirect_to admin_contents_url, flash: { success: 'Posted!' }
    end

    private
    def find_content
      @content = Content.find(params[:content_id])
    end
  end
end
