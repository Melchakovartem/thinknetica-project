# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


ready = ->
  $('.questions').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();



App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow',
  received: (data) ->
    $('.questions').append(JST["templates/question"]({ question: data }))
})

connect_to_answer_channel = ->
  return unless gon.question
  App.cable.subscriptions.create(channel: 'AnswersChannel', id: gon.question.id, {
    connected: ->
      return unless gon.question
      @perform 'follow'
    received: (data) ->
      $('.answers').append(JST["templates/answer"]({ answer: data }))
  })

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
$(document).ready(connect_to_answer_channel);
$(document).on('page:load', connect_to_answer_channel);
$(document).on('page:update', connect_to_answer_channel);
