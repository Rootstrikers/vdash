class PostsController < AdminController
  before_filter :find_content, only: [:create]

  def index
    @posts = Post.order('created_at desc').paginate(page: params[:page])
  end

  def create
    @content.post!
    redirect_to contents_url, flash: { success: 'Posted!' }
  end

  private
  def find_content
    @content = content_class.find(params[:content_id])
  end

  # TODO: Really need to merge Twitter/FacebookContent and use STI.
  def content_class
    case params[:content_type]
    when 'twitter' then TwitterContent
    when 'facebook' then FacebookContent
    end
  end

  def contents_url
    case params[:content_type]
    when 'twitter' then twitter_contents_url
    when 'facebook' then facebook_contents_url
    end
  end
end
