$ ->
  $('a.clickable').click (e) ->
    $.post '/clicks',
      item_klass: $(@).data('itemKlass'),
      item_id: $(@).data('itemId')
