class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  def create
    return unless ["Question", "Answer"].include? params[:comment][:commentable_type]
    @comment = current_user.comments.create(commentable_params)
    return if @comment.errors.any?
  end

  private

    def commentable_params
      params.require(:comment).permit(:commentable_id, :commentable_type, :body)
    end

    def publish_comment
      ActionCable.server.broadcast(
        'comments',
        @comment
        )
    end
end
