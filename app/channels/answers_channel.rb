class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "questions/#{params[:id]}/answers"
  end
end
