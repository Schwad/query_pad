class VotesController < ApplicationController

  before_action :existing_votes, only: :create

  def create
    clear_opposite_votes
    if existing_votes.length > 0
      flash[:alert] = 'You have cancelled your vote'
      existing_votes.destroy_all
    else
      flash[:notice] = 'You have successfully voted!'
      @vote = Vote.create(vote_params)
    end
    redirect_to question_path(params[:vote][:question])
  end

  private

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def existing_votes
    @existing_votes ||= Vote.where(vote_params)
  end

  def vote_params
    params.require(:vote).permit(:upvote, :user_id, :votable_type, :votable_id)
  end

  def opposite_vote
    opposite = {'false': 'true', 'true': 'false'}[vote_params[:upvote].to_sym]
    @opposite_votes ||= Vote.where(vote_params.slice(:user_id, :votable_type, :votable_id).merge(upvote: opposite))
    @opposite_votes
  end

  def clear_opposite_votes
    opposite_vote.destroy_all if opposite_vote.exists?
  end
end
