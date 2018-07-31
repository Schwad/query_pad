class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  after_create :apply_vote_to_scores
  after_destroy :unapply_vote_to_scores

  private

  def apply_vote_to_scores
    if upvote?
      increment_scores
    else
      decrement_scores
    end
  end

  def unapply_vote_to_scores
    if upvote?
      decrement_scores
    else
      increment_scores
    end
  end

  def increment_scores
    votable.user.increment_score
    votable.increment_score
  end

  def decrement_scores
    votable.user.decrement_score
    votable.decrement_score
  end
end
