class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :destroy, :update]

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.user_id = current_user.id
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
    if @question.best_answer_id
      @best_answer = @answers.find(@question.best_answer_id)
    end
  end

  def index
    @questions = Question.all
  end

  def update
    if @question.user_id == current_user.id
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      redirect_to questions_path, notice: "Your question succesfully deleted"
    else
      redirect_to @question, notice: "You haven't rights for this action"
    end
  end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end

    def load_question
      @question = Question.find(params[:id])
    end
end
