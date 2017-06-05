class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:show, :update, :destroy]

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
    if @answer.user_id == current_user.id
      @answer.update(answer_params)
    end
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
      redirect_to question_path(@question), notice: "Your answer succesfully deleted"
    else
      redirect_to question_answer_path(@question, @answer), notice: "You haven't rights for this action"
    end
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

    def load_answer
      @answer = @question.answers.find(params[:id])
    end
end
