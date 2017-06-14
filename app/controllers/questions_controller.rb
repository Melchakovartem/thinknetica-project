class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :destroy, :update]

  def new
    @question = Question.new
    @question.attachments.build
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
    @answers = @question.answers.order(best: :desc)
  end

  def index
    @questions = Question.all
  end

  def update
    return unless @question.is_author?(current_user)
    @question.update(question_params)
  end

  def destroy
    if @question.is_author?(current_user)
      @question.destroy
      redirect_to questions_path, notice: "Your question succesfully deleted"
    else
      redirect_to @question, notice: "You haven't rights for this action"
    end
  end

  private

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file])
    end

    def load_question
      @question = Question.find(params[:id])
    end
end
