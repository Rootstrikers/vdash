module ApplicationHelper
  def nav_item(text, image, url, options = {})
    content_tag(:li, class: (current_page?(url) ? 'active' : '' )) do
      icon = image ? "<img src='#{image}' type='image/svg+xml'>" : ''
      link_to raw("#{icon}<h4>#{text}</h4>"), url, options
    end
  end

  def like_action_class(user, item)
    classes = ['like-action']
    classes << 'voted' if user.liked?(item)
    classes.join(' ')
  end
end
