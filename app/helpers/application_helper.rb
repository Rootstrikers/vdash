module ApplicationHelper
  def nav_item(text, url, options = {})
    content_tag(:li, class: (current_page?(url) ? 'active' : '' )) do
      link_to text, url, options
    end
  end

  def like_action_class(user, item)
    classes = ['like-action']
    classes << 'voted' if user.liked?(item)
    classes.join(' ')
  end
end
