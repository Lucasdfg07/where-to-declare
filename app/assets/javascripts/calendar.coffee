$(document).on 'turbolinks:load', ->
  $('#done_checkbox').on 'click', (e) ->
	  	$('#done_form').submit()

  $('#done_form').on 'submit', (e) ->
	$.ajax e.target.action,
	    type: 'PUT',
	    dataType: 'json',
	    data: $("#done_form").serialize()
	return false