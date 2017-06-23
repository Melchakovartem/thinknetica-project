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
      success: (data) ->
        $('#vlr-' + votable_type.toLowerCase() + '-' + votable_id).data("id", data.vote_id).show()
        $('#like-vl-' + votable_type.toLowerCase() + '-' + votable_id).hide()
        $('#dislike-vl-' + votable_type.toLowerCase() + '-' + votable_id).hide()
        $('.rating-' + votable_type.toLowerCase() + '-' + votable_id).html(data.rating)

  $(document).on 'click', '.vote-link-reset', (e) ->
    e.preventDefault();
    id =  $(this).data('id')
    $.ajax
      type: "DELETE"
      url: "/votes/"+id
      success: (data) ->
        $('#vlr-' + data.votable_type.toLowerCase() + '-' + data.votable_id).hide()
        $('#like-vl-' + data.votable_type.toLowerCase() + '-' + data.votable_id).show()
        $('#dislike-vl-' + data.votable_type.toLowerCase() + '-' + data.votable_id).show()
        $('.rating-' + data.votable_type.toLowerCase() + '-' + data.votable_id).html(data.rating)



$(document).on('turbolinks:load', vote);
$(document).on('turbolinks:update', vote);
$(document).on('page:load', vote);
$(document).on('page:update', vote);
