module ApplicationHelper
  def nav_item(text, url, options = {})
    content_tag(:li, class: (current_page?(url) ? 'active' : '' )) do
      link_to text, url, options
    end
  end
end
