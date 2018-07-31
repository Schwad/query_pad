class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :questions
  has_many :answers
  has_many :answered_questions, through: :answers, class_name: 'Question'
  has_many :votes
  has_many :voted_questions, through: :votes, source: :votable, source_type: 'Question'
  has_many :voted_answers, through: :votes, source: :votable, source_type: 'Answer'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

  def vote_cast(object)
    result = votes.where(votable_type: object.class.to_s, votable_id: object.id)[0]
    if result.blank?
      'None'
    elsif result.upvote
      'Upvote'
    else
      'Downvote'
    end
  end

  def increment_score
    User.increment_counter(:score, id)
  end

  def decrement_score
    User.decrement_counter(:score, id)
  end

  def power_user
    score.between?(25,50)
  end

  def moderator_user
    score > 50
  end
end
