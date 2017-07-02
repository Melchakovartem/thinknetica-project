class CommentsChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:id])
    stream_from "questions/#{question.id}/comments"
  end
end
