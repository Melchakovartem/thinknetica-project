require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "DELETE #destroy" do
    sign_in_user

    describe "Attachment to question" do
      context "if user is author of question" do
        let(:question) { create(:question, user: @user) }
        let(:attachment) { create(:attachment, attachmentable_id: question.id, attachmentable_type: question.class.name) }

        before { delete :destroy, params: { id: attachment }, format: :js }

        it "checks record in database" do
          expect(Attachment.where(id: attachment.id)).not_to exist
        end

        it "checks attachments for question" do
          expect(question.attachments).not_to exist
        end
      end

      context "if user isn't author of question" do
        let(:question) { create(:question) }
        let(:attachment) { create(:attachment, attachmentable_id: question.id, attachmentable_type: question.class.name) }

        before { delete :destroy, params: { id: attachment }, format: :js  }

        it "checks record in database" do
          expect(Attachment.where(id: attachment.id)).to exist
        end

        it "checks attachments for question" do
          expect(question.attachments).to exist
        end
      end
    end

    describe "Attachment to answer" do
      context "if user is author of answer" do
        let(:answer) { create(:answer, user: @user) }
        let(:attachment) { create(:attachment, attachmentable_id: answer.id, attachmentable_type: answer.class.name) }

        before { delete :destroy, params: { id: attachment }, format: :js  }

        it "checks record in database" do
          expect(Attachment.where(id: attachment.id)).not_to exist
        end

        it "checks attachments for question" do
          expect(answer.attachments).not_to exist
        end
      end

      context "if user isn't author of answer" do
        let(:answer) { create(:answer) }
        let(:attachment) { create(:attachment, attachmentable_id: answer.id, attachmentable_type: answer.class.name) }

        before { delete :destroy, params: { id: attachment }, format: :js  }

        it "checks record in database" do
          expect(Attachment.where(id: attachment.id)).to exist
        end

        it "checks attachments for question" do
          expect(answer.attachments).to exist
        end
      end
    end
  end
end
