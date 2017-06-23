class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: :create
  before_action :load_vote, only: :destroy

  def create
    return if !@votable or @votable.is_author?(current_user)
    vote = current_user.votes.create(votable_params)
    render json: { rating: @votable.rating, vote_id: vote.id }
  end

  def destroy
    return unless @vote.is_author?(current_user)
    votable = @vote.votable
    @vote.destroy
    render json: { votable_id: votable.id, votable_type: votable.class.name.underscore, rating: votable.rating }
  end

  private

    def votable_params
      params.require(:vote).permit(:votable_id, :votable_type, :value)
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end

    def load_votable
      type = params[:vote][:votable_type]
      @votable = type.constantize.find(params[:vote][:votable_id]) if ["Question", "Answer"].include? type
    end
end
