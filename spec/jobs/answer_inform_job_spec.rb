require 'rails_helper'

RSpec.describe AnswerInformJob, type: :job do
  describe "informing" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    it "sends new answer to question" do
      expect(AnswerMailer).to receive(:informing).with(user, answer).and_call_original
      AnswerInformJob.perform_now(answer)
    end
  end
end
