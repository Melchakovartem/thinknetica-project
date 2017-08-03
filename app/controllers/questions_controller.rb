class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :load_current_user
  before_action :build_answer, only: [:show]
  before_action :load_gon_question, only: [:show]

  after_action :publish_question, only: [:create]

  respond_to :js, only: [:show, :update]

  authorize_resource


  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def show
    @answers = @question.answers.order(best: :desc)
    respond_with @question
  end

  def index
    respond_with(@questions = Question.all)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  def subscribe
  end

  def unsubscribe
  end

  private

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end

    def load_question
      @question = Question.find(params[:id])
    end

    def build_answer
      @answer = @question.answers.new
    end

    def publish_question
      return unless @question.valid?
      ActionCable.server.broadcast(
        'questions',
        @question
        )
    end

    def load_current_user
      gon.user = current_user
    end

    def load_gon_question
      gon.question = @question
    end
end
