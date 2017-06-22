require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe "POST #create" do
    let(:user) { create(:user) }

    context "Vote for question" do
      context "if user authenticated" do

        sign_in_user

        context "if user is not author of question" do
          let(:question) { create(:question) }

          context "with valid attributes" do
            it "saves new like vote to database" do
              expect do
                post :create, params: { vote: {votable_id: question, value: 1, votable_type: question.class.name }, format: :js }
              end.to change(Vote, :count).by(1)
            end

            it "saves new dislike vote to database" do
              expect do
                post :create, params: { vote: {votable_id: question, value: -1, votable_type: question.class.name }, format: :js }
              end.to change(Vote, :count).by(1)
            end
          end

          context "with invalid attributes" do
            it "doesn't save new like vote to database" do
              expect do
                post :create, params: { vote: {votable_id: question, value: 0, votable_type: question.class.name }, format: :js }
              end.not_to change(Vote, :count)
            end
          end

          context "if user has already voted" do
            let!(:vote) { create(:vote, votable_id: question.id, votable_type: question.class.name, user: @user, value: 1) }

            it "doesn't save new like vote to database" do
              expect do
                post :create, params: { vote: {votable_id: question, value: 1, votable_type: question.class.name }, format: :js }
              end.to_not change(Vote, :count)
            end
          end
        end

        context "if user is author of question" do
          let(:question) { create(:question, user: @user) }

          it "doesn't save new like vote to database" do
            expect do
              post :create, params: { vote: {votable_id: question, value: 1, votable_type: question.class.name }, format: :js }
            end.not_to change(Vote, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let(:question) { create(:question) }

        it "doesn't save new like vote to database" do
          expect do
            post :create, params: { vote: {votable_id: question, value: 1, votable_type: question.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end

        it "doesn't save new like vote to database" do
          expect do
            post :create, params: { vote: {votable_id: question, value: -1, votable_type: question.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end
      end
    end

    context "Vote for answer" do

      context "if user authenticated" do

        sign_in_user

        context "if user is not author of answer" do
          let(:answer) { create(:answer) }

          context "with valid attributes" do
            it "saves new like vote to database" do
              expect do
                post :create, params: { vote: {votable_id: answer, value: 1, votable_type: answer.class.name }, format: :js }
              end.to change(Vote, :count).by(1)
            end

            it "saves new dislike vote to database" do
              expect do
                post :create, params: { vote: {votable_id: answer, value: -1, votable_type: answer.class.name }, format: :js }
              end.to change(Vote, :count).by(1)
            end
          end

          context "with invalid attributes" do
            it "doesn't save new like vote to database" do
              expect do
                post :create, params: { vote: {votable_id: answer, value: 0, votable_type: answer.class.name }, format: :js }
              end.not_to change(Vote, :count)
            end
          end
        end

        context "if user is author of answer" do
          let(:answer) { create(:answer, user: @user) }

          it "doesn't save new like vote to database" do
            expect do
              post :create, params: { vote: {votable_id: answer, value: 1, votable_type: answer.class.name }, format: :js }
            end.not_to change(Vote, :count)
          end
        end

        context "if user has already voted" do
          let(:answer) { create(:answer, user: @user) }
          let!(:vote) { create(:vote, votable_id: answer.id, votable_type: answer.class.name, user: @user, value: 1) }

          it "doesn't save new like vote to database" do
            expect do
              post :create, params: { vote: {votable_id: answer, value: 1, votable_type: answer.class.name }, format: :js }
            end.to_not change(Vote, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let(:answer) { create(:answer) }

        it "doesn't save new like vote to database" do
          expect do
            post :create, params: { vote: {votable_id: answer, value: 1, votable_type: answer.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end

        it "doesn't save new like vote to database" do
          expect do
            post :create, params: { vote: {votable_id: answer, value: -1, votable_type: answer.class.name }, format: :js }
          end.not_to change(Vote, :count)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "Delete vote for question" do
      let(:question) { create(:question) }

      context "if user authenticated" do
        let(:user) { create(:user) }

        sign_in_user

        context "if user is autor of vote" do
          let!(:vote) { create(:vote, votable_id: question.id, votable_type: question.class.name, value: 1, user_id: @user.id) }

          it "deletes vote from database" do
            expect do
              delete :destroy, params: { vote: {votable_id: question, votable_type: question.class.name }, format: :js }
            end.to change(Vote, :count).by(-1)
          end
        end

        context "if user is not autor of vote" do
          let(:not_author) { create(:user) }
          let!(:vote) { create(:vote, votable_id: question.id, votable_type: question.class.name, value: 1, user: not_author) }

          it "deletes vote from database" do
            expect do
              delete :destroy, params: { vote: {votable_id: question, votable_type: question.class.name }, format: :js }
            end.to_not change(Vote, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let!(:vote) { create(:vote, votable_id: question.id, votable_type: question.class.name, value: 1) }

        it "doesn't delete vote from database" do
          expect do
            delete :destroy, params: { vote: {votable_id: question, votable_type: question.class.name }, format: :js }
          end.to_not change(Vote, :count)
        end
      end
    end

    context "Delete vote for answer" do
      let(:answer) { create(:answer) }

      context "if user authenticated" do
        let(:user) { create(:user) }

        sign_in_user

        context "if user is autor of vote" do
          let!(:vote) { create(:vote, votable_id: answer.id, votable_type: answer.class.name, value: 1, user_id: @user.id) }

          it "deletes vote from database" do
            expect do
              delete :destroy, params: { vote: {votable_id: answer, votable_type: answer.class.name }, format: :js }
            end.to change(Vote, :count).by(-1)
          end
        end

        context "if user is not autor of vote" do
          let!(:vote) { create(:vote, votable_id: answer.id, votable_type: answer.class.name, value: 1) }

          it "deletes vote from database" do
            expect do
              delete :destroy, params: { vote: {votable_id: answer, votable_type: answer.class.name }, format: :js }
            end.to_not change(Vote, :count)
          end
        end
      end

      context "if user unauthenticated" do
        let!(:vote) { create(:vote, votable_id: answer.id, votable_type: answer.class.name, value: 1) }

        it "doesn't delete vote from database" do
          expect do
            delete :destroy, params: { vote: {votable_id: answer, votable_type: answer.class.name }, format: :js }
          end.to_not change(Vote, :count)
        end
      end
    end
  end
end
