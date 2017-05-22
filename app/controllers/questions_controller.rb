class QuestionsController < ApplicationController
  before_action :load_question, only: [:show]
  before_action :authenticate_user!, except: %i[index show]

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show; end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end

    def load_question
      @question = Question.find(params[:id])
    end
end