$ ->
  $('#post-submissions a').click (e) ->
    e.preventDefault()
    $(@).tab('show')
