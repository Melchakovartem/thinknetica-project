class CommentsController < ApplicationController
  before_action :authenticate_user!



  def create
    return unless ["Question", "Answer"].include? params[:comment][:commentable_type]
    comment = current_user.comments.create(commentable_params)
    render json: comment
  end

  private

    def commentable_params
      params.require(:comment).permit(:commentable_id, :commentable_type, :body)
    end


end
