class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: :create
  before_action :load_vote, only: :destroy

  def create
    return if @votable.is_author?(current_user)
    vote = current_user.votes.create(votable_params)
  end

  def destroy
    return unless @vote.is_author?(current_user)
    @vote.destroy
  end

  private

    def votable_params
      params.require(:vote).permit(:votable_id, :votable_type, :value)
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end

    def load_votable
      @votable = params[:vote][:votable_type].constantize.find(params[:vote][:votable_id])
    end
end
