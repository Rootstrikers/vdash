$ ->
  $('a.like-action').click (e) ->
    e.preventDefault()

    $(@).toggleClass('voted')
    $.post '/likes',
      item_klass: $(@).data('itemKlass'),
      item_id: $(@).data('itemId')
