class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, except: [:select]
  before_action :load_answer, only: [:show, :update, :destroy, :select]

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
    end
  end

  def select
    @question = @answer.question
    if current_user.id == @question.user_id
      @question.update(best_answer_id: @answer.id)
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
      @answer = Answer.find(params[:id])
    end
end
