require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:user) }

    context "Comment from question" do
      let(:question) { create(:question) }
      context "if user authenticated" do

        sign_in_user

        context "with valid attributes" do
          it "saves new comment to database" do
            expect do
              post :create, params: { comment: { body: "new cooment", commentable_id: question, commentable_type: question.class.name }, format: :js }
            end.to change(Comment, :count).by(1)
          end
        end

        context "with invalid attributes" do
          it "doesn't save new vote to database if body is empty" do
            expect do
              post :create, params: { comment: { body: "", commentable_id: question, commentable_type: question.class.name }, format: :js }
            end.not_to change(Comment, :count)
          end

          it "doesn't save new vote to database if incorrect votable_type" do
            expect do
              post :create, params: { comment: { body: "new comment", commentable_id: question, commentable_type: "incorrect" }, format: :js }
            end.not_to change(Vote, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let(:question) { create(:question) }

        it "doesn't save new comment to database" do
          expect do
            post :create, params: { comment: { body: "new comment", commentable_id: question, commentable_type: question.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end
      end
    end

    context "Comment from answer" do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }

      context "if user authenticated" do

        sign_in_user

        context "with valid attributes" do
          it "saves new comment to database" do
            expect do
              post :create, params: { comment: { body: "new cooment", commentable_id: answer, commentable_type: answer.class.name }, format: :js }
            end.to change(Comment, :count).by(1)
          end
        end

        context "with invalid attributes" do
          it "doesn't save new vote to database if body is empty" do
            expect do
              post :create, params: { comment: { body: "", commentable_id: answer, commentable_type: answer.class.name }, format: :js }
            end.not_to change(Comment, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let(:question) { create(:question) }

        it "doesn't save new comment to database" do
          expect do
            post :create, params: { comment: { body: "new comment", commentable_id: answer, commentable_type: answer.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end
      end
    end
  end
end
