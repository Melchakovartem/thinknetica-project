# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

vote = ->
  $(document).on 'click', '.vote-link', (e) ->
    e.preventDefault();
    value = $(this).data('value')
    votable_id =  $(this).data('votable-id')
    votable_type =  $(this).data('votable-type')
    $.ajax
      type: "POST"
      url: "/votes"
      data:
        vote:
          value: value
          votable_type: votable_type
          votable_id: votable_id
      success: (rating) ->
        $('#vlr-' + votable_type.toLowerCase() + '-' + votable_id).show()
        $('#like-vl-' + votable_type.toLowerCase() + '-' + votable_id).hide()
        $('#dislike-vl-' + votable_type.toLowerCase() + '-' + votable_id).hide()
        $('.rating-' + votable_type.toLowerCase() + '-' + votable_id).html(rating)

  $(document).on 'click', '.vote-link-reset', (e) ->
    e.preventDefault()
    votable_id =  $(this).data('votable-id')
    votable_type =  $(this).data('votable-type')
    $.ajax
      type: "DELETE"
      url: "/votes"
      data:
        vote:
          votable_type: votable_type
          votable_id: votable_id
      success: (rating) ->
        $('#vlr-' + votable_type.toLowerCase() + '-' + votable_id).hide()
        $('#like-vl-' + votable_type.toLowerCase() + '-' + votable_id).show()
        $('#dislike-vl-' + votable_type.toLowerCase() + '-' + votable_id).show()
        $('.rating-' + votable_type.toLowerCase() + '-' + votable_id).html(rating)



$(document).on('turbolinks:load', vote)
$(document).on('page:load', vote);
$(document).on('page:update', vote);
