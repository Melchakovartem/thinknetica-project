require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "informing" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { AnswerMailer.informing(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Informing")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["melchakovartem@mail.ru"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
