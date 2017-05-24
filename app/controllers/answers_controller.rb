class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to question_answers_path(@question),
      notice: "Your answer succefully created"
    else
      render :new
    end
  end

  def index
    @answers = @question.answers
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
