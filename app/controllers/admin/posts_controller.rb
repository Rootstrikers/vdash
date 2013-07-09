module Admin
  class PostsController < AdminController
    skip_before_filter :require_admin, only: [:facebook_callback]

    before_filter :find_content, only: [:create, :facebook_callback]

    def index
      @posts = Post.order('created_at desc').paginate(page: params[:page])
    end

    def create
      if params[:type] == 'facebook'
        redirect_to "https://www.facebook.com/dialog/feed?#{facebook_params.to_query}"
      elsif params[:type] == 'twitter'

      end
    end

    def facebook_callback
      @content.post!(service: :facebook)
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
        redirect_uri: facebook_callback_admin_posts_url(content_id: @content_id)
      }
    end

  end
end
