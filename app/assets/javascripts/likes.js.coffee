$ ->
  window.attachLikeListener = ->
    $('a.like-action').click (e) ->
      e.preventDefault()

      $.post '/likes',
        {
          item_klass: $(@).data('itemKlass'),
          item_id: $(@).data('itemId')
        },
        (data) =>
          if data.status == 'ok'
            $(@).toggleClass('voted')
            vote_count = $("span#upvote-count-#{data.itemKlass}-#{data.id}")
            vote_count.text(data.like_count)
            if data.liked and data.itemKlass == 'Link'
              more_info_section = $("#post-ideas-for-link-#{data.id}")
              unless more_info_section.hasClass('opened-info')
                $('a.more-info-toggle', more_info_section).click()
                $('a.collapse-toggle', more_info_section).click()
          else if data.status == 'needs_click'
            alert('Please click the link and read the article/site before voting on it.')

  window.attachLikeListener()
