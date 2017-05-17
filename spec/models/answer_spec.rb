require "rails_helper"

RSpec.describe Answer, type: :model do
  let(:question) { create(:question, title: "title question", body: "body question") }
  let(:answer) { create(:answer, body: "body answer", question: question) }

  it { should validate_presence_of :body }

  it "validates answer belongs to question" do
    expect(answer.question_id).to eq(question.id)
  end
end
