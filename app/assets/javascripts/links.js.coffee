$ ->
  $('input#link_url').blur (e) ->
    url = $(@).val()
    $.get "/remote_link/?url=#{url}", (data) ->
      $('input#link_title').val(data.title) if $('input#link_title').val() == ''
      $('textarea#link_summary').val(data.first_paragraph) if $('textarea#link_summary').val() == ''
