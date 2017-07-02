class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question_id

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
        "questions/#{@question_id}/comments",
        @comment
        )
    end

    def load_question_id

      if params[:comment][:commentable_type] == "Question"
        @question_id = Question.find(params[:comment][:commentable_id]).id
      elsif params[:comment][:commentable_type] == "Answer"
        @question_id = Answer.find(params[:comment][:commentable_id]).question.id
      end
    end
end
