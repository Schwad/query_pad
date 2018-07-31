class Answer < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :question, touch: true
  has_many :votes, as: :votable

  validates :body, presence: true

  def question_title
    question&.title
  end

  def increment_score
    Answer.increment_counter(:score, id)
  end

  def decrement_score
    Answer.decrement_counter(:score, id)
  end
end
