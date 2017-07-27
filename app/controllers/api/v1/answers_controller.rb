class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers, each_serializer: BasicAnswerSerializer
  end

  def show
    respond_with @answer, serializer: AnswerSerializer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question_id: @question.id))
    respond_with @answer, serializer: BasicAnswerSerializer, location: api_v1_question_answers_path
  end

  private

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
