class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:show, :update, :destroy, :select]
  before_action :load_current_user

  after_action :publish_answer, only: [:create]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def index
    @answers = @question.answers
  end

  def update
    if @answer.is_author?(current_user)
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
    end
  end

  def select
    return unless @question.is_author?(current_user)
    @question.select_answer(@answer)
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def publish_answer
      return if @question.errors.any?
      answer = @answer.as_json
      answer[:rating] = @answer.rating
      answer[:question] = @answer.question
      answer[:attachments] = @answer.attachments.map {|a| { id: a.id, filename: a.file.filename, url: a.file.url , user_id: @answer.user_id } }
      ActionCable.server.broadcast(
        "questions/#{@question.id}/answers",
        answer
        )
    end

    def load_current_user
      gon.user = current_user
    end
end
