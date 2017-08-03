# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

subscribing = ->
  $(document).on 'click', '.subscribe-link', (e) ->
    e.preventDefault();
    question_id =  $(this).data('question-id')
    $.ajax
      type: "POST"
      url: "/subscriptions"
      data:
        subscription:
          question_id: question_id
      success: (data) ->
        console.log(data.subscription_id)
        $('.unsubscribe-link').data("id", data.subscription_id).show()
        $('.subscribe-link').hide()

  $(document).on 'click', '.unsubscribe-link', (e) ->
    e.preventDefault();
    id =  $(this).data('id')
    console.log(id)
    $.ajax
      type: "DELETE"
      url: "/subscriptions/"+id
      success: (data) ->
        $('.unsubscribe-link').hide()
        $('.subscribe-link').show()




$(document).on('turbolinks:load', subscribing);
$(document).on('turbolinks:update', subscribing);
$(document).on('page:load', subscribing);
$(document).on('page:update', subscribing);
