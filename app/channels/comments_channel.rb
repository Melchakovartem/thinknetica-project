class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "questions/#{params[:id]}/comments"
  end
end
