class AnswersController < ApplicationController
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      flash[:notice] = "Your answer succefully created"
      redirect_to question_answers_path(@question)
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
