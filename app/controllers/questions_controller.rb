class QuestionsController < ApplicationController
  before_action :load_question, only: [:show]

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      flash[:notice] = "Your question succesfully created"
      redirect_to @question
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.all
  end

  def index
    @questions = Question.all
  end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end

    def load_question
      @question = Question.find(params[:id])
    end
end
