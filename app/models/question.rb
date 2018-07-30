class Question < ApplicationRecord
  include PgSearch
  acts_as_paranoid
  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, presence: true

  pg_search_scope :search_for, against: %i[title body], using: %i[tsearch trigram]

  def increment_score
    Question.increment_counter(:score, id)
  end

  def decrement_score
    Question.decrement_counter(:score, id)
  end
end
