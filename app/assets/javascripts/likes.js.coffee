$ ->
  $('a.like-action').click (e) ->
    e.preventDefault()

    $(@).toggleClass('voted')
    $.post '/likes',
      {
        item_klass: $(@).data('itemKlass'),
        item_id: $(@).data('itemId')
      },
      (data) ->
        vote_count = $("span#upvote-count-#{data.itemKlass}-#{data.id}")
        vote_count.text(data.like_count)
