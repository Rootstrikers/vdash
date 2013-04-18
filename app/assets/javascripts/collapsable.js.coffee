$ ->
  $('.collapse-toggle').click (e) ->
    e.preventDefault()

    $(this).toggleClass('expanded')
    if $(this).hasClass('expanded')
      $(this).html("Hide <i class='icon-chevron-up'></i>")
    else # TODO: Make this more reusable
      $(this).html("Write a new post <i class='icon-chevron-down'></i>")

    target = $($(this).data('target-selector'))
    target.toggle('fast')
