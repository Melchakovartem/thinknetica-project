class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: BasicQuestionSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question, serializer: BasicQuestionSerializer
  end

  private

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
