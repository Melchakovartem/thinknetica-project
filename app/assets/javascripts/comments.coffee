# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


comment = ->
  $('.question').on 'click','a.comment-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.comment-question').show()

  $('.answers').on 'click','a.comment-answer-link', (e) ->
    e.preventDefault()
    question_id = $(this).attr('id');
    $(this).hide()
    $('form#'+question_id).show()

  $('form.comment-question').on 'submit', (e) ->
    $(this).hide()

  $('form.comment-answer').on 'submit', (e) ->
    $(this).hide()

connect_to_comment_channel = ->
  return unless gon.question
  App.cable.subscriptions.create(channel: 'CommentsChannel', id: gon.question.id, {
    connected: ->
      @perform 'follow',
    received: (data) ->
      $("." + data.commentable_type.toLowerCase() + "-" + data.commentable_id + ' .list-of-comments').append("<li>" + data.body + "</li>")
      $('a#comment-' + data.commentable_type.toLowerCase() + '-' + data.commentable_id).show()
  })

$(document).ready(comment);
$(document).on('page:load', comment);
$(document).on('page:update', comment);
$(document).ready(connect_to_comment_channel);
$(document).on('page:load', connect_to_comment_channel);
$(document).on('page:update', connect_to_comment_channel);

