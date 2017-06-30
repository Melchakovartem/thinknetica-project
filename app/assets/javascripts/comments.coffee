# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


comment = ->
  $('.question').on 'click','a.comment-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.comment-question').show()

  $('form.comment-question').on 'submit', (e) ->
    $(this).hide()

  $('form.comment-answer').on 'submit', (e) ->
    $(this).hide()

$(document).ready(comment);
$(document).on('page:load', comment);
$(document).on('page:update', comment);
