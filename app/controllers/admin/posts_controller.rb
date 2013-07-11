module Admin
  class PostsController < AdminController
    skip_before_filter :require_admin, only: [:callback]

    before_filter :find_content, only: [:create, :callback]

    def index
      @posts = Post.order('created_at desc').paginate(page: params[:page])
    end

    def create
      if params[:type] == 'facebook'
        redirect_to "https://www.facebook.com/dialog/feed?#{facebook_params.to_query}"
      end
    end

    def callback
      @content.post!(service: params[:service].to_sym)
      redirect_to contents_url, flash: { success: 'Posted!' }
    end

    private
    def find_content
      @content = Content.find(params[:content_id])
    end

    def facebook_params
      {
        app_id:       ENV['FACEBOOK_API_KEY'],
        from:         '380776225267938',
        link:         @content.link_url,
        name:         @content.link_title,
        description:  @content.body,
        redirect_uri: callback_admin_posts_url(content_id: @content.id, service: 'facebook')
      }
    end

  end
end
